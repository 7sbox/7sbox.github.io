// Renders web/index.html at several viewport widths and reports layout facts the stylesheet
// cannot assert on its own -- above all, whether the page scrolls sideways at a phone width.
//
// The CSS-only design has no runtime, and check_page.py can only read text. This is the "look at
// it" step: run it after editing index.html or style.css, then open the PNGs it writes.
//
// Needs Node 18+ and Edge (or Chrome). No packages, no network.
//
//   node web/shoot.mjs                 # viewport screenshots into web/.shots
//   node web/shoot.mjs --full          # one PNG per width, whole page
//   node web/shoot.mjs --out some/dir
//
// Exit code is non-zero if any width overflows horizontally, so it can gate a release.

import { spawn } from "node:child_process";
import { existsSync, mkdirSync, writeFileSync } from "node:fs";
import { dirname, join, resolve } from "node:path";
import { fileURLToPath } from "node:url";

const HERE = dirname(fileURLToPath(import.meta.url));
const PAGE = "file:///" + resolve(HERE, "index.html").replace(/\\/g, "/");

const BROWSERS = [
  "C:\\Program Files (x86)\\Microsoft\\Edge\\Application\\msedge.exe",
  "C:\\Program Files\\Microsoft\\Edge\\Application\\msedge.exe",
  "C:\\Program Files\\Google\\Chrome\\Application\\chrome.exe",
  "C:\\Program Files (x86)\\Google\\Chrome\\Application\\chrome.exe",
  "/usr/bin/google-chrome",
  "/usr/bin/chromium",
  "/Applications/Google Chrome.app/Contents/MacOS/Google Chrome",
];

// width, height, deviceScaleFactor. 360 is the narrowest phone still in common use; 1440 is a
// laptop, where the two-column layout has to hold.
const VIEWPORTS = [
  ["desktop", 1440, 900, 1],
  ["laptop", 1180, 820, 1],
  ["tablet", 820, 1100, 1],
  ["phone", 390, 900, 2],
  ["narrow", 360, 800, 2],
];

const args = process.argv.slice(2);
const full = args.includes("--full");
const outIndex = args.indexOf("--out");
const outDir = resolve(outIndex >= 0 ? args[outIndex + 1] : join(HERE, ".shots"));
const port = 9339 + Math.floor(Math.random() * 200);

const browserPath = BROWSERS.find((path) => existsSync(path));
if (!browserPath) {
  console.error("No Edge or Chrome found. Install one, or open index.html yourself.");
  process.exit(2);
}

mkdirSync(outDir, { recursive: true });

const browser = spawn(browserPath, [
  "--headless=new",
  "--disable-gpu",
  "--hide-scrollbars",
  "--no-first-run",
  "--no-default-browser-check",
  "--disable-crash-reporter",
  `--remote-debugging-port=${port}`,
  `--user-data-dir=${join(process.env.TEMP ?? "/tmp", `rw-shoot-${port}`)}`,
  "about:blank",
], { stdio: "ignore" });

const sleep = (ms) => new Promise((done) => setTimeout(done, ms));

async function devtoolsUrl() {
  for (let attempt = 0; attempt < 80; attempt++) {
    try {
      const response = await fetch(`http://127.0.0.1:${port}/json/version`);
      return (await response.json()).webSocketDebuggerUrl;
    } catch {
      await sleep(250);
    }
  }
  throw new Error("the browser never opened a devtools endpoint");
}

class Cdp {
  constructor(url) {
    this.socket = new WebSocket(url);
    this.next = 0;
    this.pending = new Map();
    this.ready = new Promise((done, failed) => {
      this.socket.onopen = done;
      this.socket.onerror = failed;
    });
    this.socket.onmessage = (event) => {
      const message = JSON.parse(event.data);
      const entry = this.pending.get(message.id);
      if (!entry) return;
      this.pending.delete(message.id);
      if (message.error) entry.reject(new Error(JSON.stringify(message.error)));
      else entry.resolve(message.result);
    };
  }

  send(method, params = {}, sessionId) {
    const id = ++this.next;
    this.socket.send(JSON.stringify({ id, method, params, sessionId }));
    return new Promise((resolve, reject) => this.pending.set(id, { resolve, reject }));
  }
}

let failures = 0;

try {
  const cdp = new Cdp(await devtoolsUrl());
  await cdp.ready;
  const { targetId } = await cdp.send("Target.createTarget", { url: "about:blank" });
  const { sessionId } = await cdp.send("Target.attachToTarget", { targetId, flatten: true });

  for (const [name, width, height, scale] of VIEWPORTS) {
    await cdp.send("Emulation.setDeviceMetricsOverride",
      { width, height, deviceScaleFactor: scale, mobile: width < 700 }, sessionId);
    await cdp.send("Page.navigate", { url: PAGE }, sessionId);
    await sleep(900);

    const measured = await cdp.send("Runtime.evaluate", {
      expression: `JSON.stringify({
        client: document.documentElement.clientWidth,
        scroll: document.documentElement.scrollWidth,
        height: document.documentElement.scrollHeight
      })`,
      returnByValue: true,
    }, sessionId);
    const view = JSON.parse(measured.result.value);

    // The whole page must fit the viewport width; overflow means a wide element is sticking out.
    const overflow = view.scroll - view.client;
    const verdict = overflow > 0 ? `OVERFLOW +${overflow}px` : "fits";
    if (overflow > 0) failures++;

    const shot = await cdp.send("Page.captureScreenshot",
      { format: "png", captureBeyondViewport: full }, sessionId);
    const file = join(outDir, `${name}.png`);
    writeFileSync(file, Buffer.from(shot.data, "base64"));

    console.log(`${name.padEnd(8)} ${width}x${height}  client=${view.client} ` +
      `scroll=${view.scroll} height=${view.height}  ${verdict}  -> ${file}`);
  }

  await cdp.send("Browser.close");
} finally {
  browser.kill();
}

if (failures > 0) {
  console.error(`\n${failures} viewport(s) scroll sideways.`);
  process.exit(1);
}
console.log("\nall viewports fit their width.");
