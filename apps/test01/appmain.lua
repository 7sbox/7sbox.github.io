local Styles = {
    tool_panel_split = {
        tag="frame", width="full", height=6,
        background_color=ui.color:rgb(100,100,100),
        --background_color=ui.color:rgb(255,255,255),
        OnDragStart=function(this,x,y,zDelta)
            if this.Previous then
                this.y = y
                this.th = this.Previous.height
            end
        end,
        OnDragDstMove=function(this,x,y,zDelta)
            if this.Previous then
                local iy = y-this.y+this.th
                if iy<120 then iy=120 end
                this.Previous.height=iy
            end
        end,
        OnDragDstEnd=function(this,x,y,zDelta)
            if this.Previous then
                local iy = y-this.y+this.th
                if iy<120 then iy=120 end
                this.Previous.height=iy
            end
        end,
    },
    tool_split = {
        tag="space", width="full", height=3
    },
    tool_split_dark = {
        tag="frame", width="full", height=2,
        background_color=ui.color:rgb(128,128,128,128),
    },
    toolicon = {
        width=32, height=32,
        align="center", valign="center",
        background_color=0,
        border_color=ui.color:rgb(50,0,0,0),
        color=ui.color:rgb(250,250,250),
        color_check=ui.color:rgb(150,150,150),
        checked=false,
        CrossChilds=true,
        OnMouseOver=function(this,x,y,zDelta)
            this.border=1
            this.background_color=this.color
        end,
        OnMouseOut=function(this,x,y,zDelta)
            if true==this.checked then
                this.border=1
                this.background_color=this.color_check
            else
                this.border=0
                this.background_color=0
            end
        end,
        OnLeftMouseClick=function(this,x,y,zDelta)
            local rows = this.parent:getitems("toolicon")
            for i,v in ipairs(rows) do
                v.checked = false
                v.border=0
                v.background_color=0
            end
            this.checked = true
            this.border=1
            this.background_color=this.color_check
            if this.parent.parent.OnMessage then
                this.parent.parent.OnMessage(this.parent.parent,"wb_tool",this.toolname)
            end
        end,
    },
    toolicon_nofocus = {
        width=32, height=32,
        align="center", valign="center",
        background_color=0,
        border_color=ui.color:rgb(50,0,0,0),
        color=ui.color:rgb(100,200,200,200),
        color_click=ui.color:rgb(250,100,100),
        OnMouseOver=function(this,x,y,zDelta)
            this.border=1
            this.background_color=this.color
        end,
        OnMouseOut=function(this,x,y,zDelta)
            this.border=0
            this.background_color=0
        end,
        OnLeftMouseDown=function(this,x,y,zDelta)
            this.border=1
            this.background_color=this.color_click
        end,
        OnLeftMouseUp=function(this,x,y,zDelta)
            this.border=1
            this.background_color=this.color
        end,
        OnLeftMouseClick=function(this,x,y,zDelta)
            if this.parent.parent.OnMessage then
                this.parent.parent.OnMessage(this.parent.parent,"wb_tool",this.toolname)
            end
        end,
    },
}
local popwin_resize_config = {
    title="画板尺寸",
    resizeable=false,
    oncreate=function(this)
        window:HideTitle(true)
        window:setclientsize(300,200)
    end,
    OnActive=function(this,bActive,bInProcess)
        if true==bActive then
            window.body[1].background_color=window.color
        else
            window.body[1].background_color=ui.color:rgb(50,50,50)
        end
    end,
    OnKeyUp=function(this,ch)
        if ch==0x1B then
            this:Close()
        end
    end,
    -------------------------------------------------------------------------------
    body = {
        background_color=ui.color:rgb(255,255,255),
        align="center", valign="top", textalign="center",
        --Cross=true,
        OnMessage=function(this,message,param)
            if message=="init" then
                this:getid("wb_x").value = tostring(param.x)
                this:getid("wb_y").value = tostring(param.y)
                this:getid("wb_width").value = tostring(param.width)
                this:getid("wb_height").value = tostring(param.height)
            end
        end,
        {
            tag="frame",
            width="full", height=35,
            background_color=window.color,
            OnLeftMouseDown=function(this,x,y,zDelta)
                window:StartMove()
            end,
            {
                tag="text",
                Cross=true,
                height="full", padding=5,
                font_size=16, font_color=ui.color:rgb(255,255,255),
                align="left", valign="center", textalign="middle",
                text="设置画板大小",
            }
        },
        { tag="space", width="full", height=15 },
        {
            tag="frame",
            width="full", height=30,
            align="center", valign="center", textalign="center",
            {
                tag="text",
                width=60,height=30,
                align="right", valign="center", textalign="right",
                font_size=16,
                text="X:"
            },
            {
                tag="input",
                id="wb_x",
                width=100,height=30,
                font_size=16,
                value="",
                OnMouseWheel=function(this,x,y,zDelta)
                    local val = tonumber(this.value)
                    val = math.tointeger(val + 1 * zDelta/120)
                    this.value = tostring(val)
                end,
            },
        },
        { tag="space", width="full", height=5 },
        {
            tag="frame",
            width="full", height=30,
            align="center", valign="center", textalign="center",
            {
                tag="text",
                width=60,height=30,
                align="right", valign="center", textalign="right",
                font_size=16,
                text="Y:"
            },
            {
                tag="input",
                id="wb_y",
                width=100,height=30,
                font_size=16,
                value="",
                OnMouseWheel=function(this,x,y,zDelta)
                    local val = tonumber(this.value)
                    val = math.tointeger(val + 1 * zDelta/120)
                    this.value = tostring(val)
                end,
            },
        },
        { tag="space", width="full", height=5 },
        {
            tag="frame",
            width="full", height=30,
            align="center", valign="center", textalign="center",
            {
                tag="text",
                width=60,height=30,
                align="right", valign="center", textalign="right",
                font_size=16,
                text="宽度:"
            },
            {
                tag="input",
                id="wb_width",
                width=100,height=30,
                font_size=16,
                value="",
                OnMouseWheel=function(this,x,y,zDelta)
                    local val = tonumber(this.value)
                    val = math.tointeger(val + 1 * zDelta/120)
                    this.value = tostring(val)
                end,
            },
        },
        { tag="space", width="full", height=5 },
        {
            tag="frame",
            width="full", height=30,
            align="center", valign="center", textalign="center",
            {
                tag="text",
                width=60,height=30,
                align="right", valign="center", textalign="right",
                font_size=16,
                text="高度:"
            },
            {
                tag="input",
                id="wb_height",
                width=100,height=30,
                font_size=16,
                value="",
                OnMouseWheel=function(this,x,y,zDelta)
                    local val = tonumber(this.value)
                    val = math.tointeger(val + 1 * zDelta/120)
                    this.value = tostring(val)
                end,
            },
        },
        { tag="space", width="full", height=10 },
        {
            tag="frame",
            width="full", height=30,
            align="center", valign="center", textalign="center",
            {
                tag="button",
                width=80,height=30,
                text="取消",
                OnLeftMouseClick=function(this,x,y,zDelta)
                    window:Close()
                end,
            },
            { tag="space", width=5, height=5 },
            {
                tag="button",
                text="确定",
                width=80,height=30,
                OnLeftMouseClick=function(this,x,y,zDelta)
                    window:PopupCallBack("wbconfig",{
                        wb_x=tonumber(window.body:getid("wb_x").value),
                        wb_y=tonumber(window.body:getid("wb_y").value),
                        wb_width=tonumber(window.body:getid("wb_width").value),
                        wb_height=tonumber(window.body:getid("wb_height").value)
                    })
                    window:Close()
                end,
            },
        }
    }
}
local popwin_brush_config = {
    title="画笔",
    --resizeable=false,
    oncreate=function(this)
        window:HideTitle(true)
        window:setclientsize(400,300)
        --window:SetClientSize(1280,720+50)
    end,
    OnActive=function(this,bActive,bInProcess)
        if true==bActive then
            window.body[1].background_color=window.color
        else
            window:Close()
        end
    end,
    OnKeyUp=function(this,ch)
        if ch==0x1B then
            this:Close()
        end
    end,
    -------------------------------------------------------------------------------
    body = {
        background_color=ui.color:rgb(255,255,255),
        align="center", valign="top", textalign="center",
        Cross=true,
        OnMessage=function(this,message,param)
            if message=="init" then
                window.body:getid("wb_brush_width").value = tonumber(param.wb_brush_width)
                window.body:getid("wb_brush_alpha").value = tonumber(param.wb_brush_alpha)
            end
        end,
        {
            tag="frame",
            width="full", height=35,
            background_color=window.color,
            OnLeftMouseDown=function(this,x,y,zDelta)
                window:StartMove()
            end,
            {
                tag="text",
                Cross=true,
                height="full", padding=5,
                font_size=16, font_color=ui.color:rgb(255,255,255),
                align="left", valign="center", textalign="middle",
                text="画笔设置",
            }
        },
        {
            tag="frame",
            width="full", height="fill",
            {
                tag="frame",
                width="full", height=40,
                align="left", valign="center", textalign="middle",
                {
                    tag="text",
                    text="宽度",
                },
                {
                    id="wb_brush_width",
                    tag="sliderbar",
                    margin=5,
                    width="fill", height=30,
                    region_color=ui.color:rgb(233,233,233),
                    range_color=ui.color:rgb(73,110,243),
                    slider_color=ui.color:rgb(240,240,240),
                    range_begin=1, range_end=100,
                    value=100,
                    OnDragStart=function(this,x,y,zDelta)
                        window:PopupCallBack("wbconfig",{
                            wb_brush_width=tonumber(window.body:getid("wb_brush_width").value),
                            wb_brush_alpha=tonumber(window.body:getid("wb_brush_alpha").value)
                        })
                    end,
                    OnDragMove=function(this,x,y,zDelta)
                        window:PopupCallBack("wbconfig",{
                            wb_brush_width=tonumber(window.body:getid("wb_brush_width").value),
                            wb_brush_alpha=tonumber(window.body:getid("wb_brush_alpha").value)
                        })
                    end,
                    OnMouseWheel=function(this,x,y,zDelta)
                        local val = tonumber(this.value)
                        val = math.tointeger(val + 1 * zDelta/120)
                        this.value = val
                        window:PopupCallBack("wbconfig",{
                            wb_brush_width=tonumber(window.body:getid("wb_brush_width").value),
                            wb_brush_alpha=tonumber(window.body:getid("wb_brush_alpha").value)
                        })
                    end,
                },
            },
            {
                tag="frame",
                width="full", height=30,
                {
                    tag="text",
                    text="不透明度:",
                },
                {
                    id="wb_brush_alpha",
                    tag="sliderbar",
                    margin=5,
                    width="fill", height=30,
                    region_color=ui.color:rgb(233,233,233),
                    range_color=ui.color:rgb(73,110,243),
                    slider_color=ui.color:rgb(240,240,240),
                    range_begin=1, range_end=255,
                    value=255,
                    OnDragStart=function(this,x,y,zDelta)
                        window:PopupCallBack("wbconfig",{
                            wb_brush_width=tonumber(window.body:getid("wb_brush_width").value),
                            wb_brush_alpha=tonumber(window.body:getid("wb_brush_alpha").value)
                        })
                    end,
                    OnDragMove=function(this,x,y,zDelta)
                        window:PopupCallBack("wbconfig",{
                            wb_brush_width=tonumber(window.body:getid("wb_brush_width").value),
                            wb_brush_alpha=tonumber(window.body:getid("wb_brush_alpha").value)
                        })
                    end,
                    OnMouseWheel=function(this,x,y,zDelta)
                        local val = tonumber(this.value)
                        val = math.tointeger(val + 1 * zDelta/120)
                        this.value = val
                        window:PopupCallBack("wbconfig",{
                            wb_brush_width=tonumber(window.body:getid("wb_brush_width").value),
                            wb_brush_alpha=tonumber(window.body:getid("wb_brush_alpha").value)
                        })
                    end,
                },
            }
        }
    }
}
local popwin_eraser_config = {
    title="橡皮",
    --resizeable=false,
    oncreate=function(this)
        window:HideTitle(true)
        window:setclientsize(400,300)
        --window:SetClientSize(1280,720+50)
    end,
    OnActive=function(this,bActive,bInProcess)
        if true==bActive then
            window.body[1].background_color=window.color
        else
            window:Close()
        end
    end,
    OnKeyUp=function(this,ch)
        if ch==0x1B then
            this:Close()
        end
    end,
    -------------------------------------------------------------------------------
    body = {
        background_color=ui.color:rgb(255,255,255),
        align="center", valign="top", textalign="center",
        Cross=true,
        OnMessage=function(this,message,param)
            if message=="init" then
                window.body:getid("wb_eraser_width").value = tonumber(param.wb_eraser_width)
                window.body:getid("wb_eraser_alpha").value = tonumber(param.wb_eraser_alpha)
            end
        end,
        {
            tag="frame",
            width="full", height=35,
            background_color=window.color,
            OnLeftMouseDown=function(this,x,y,zDelta)
                window:StartMove()
            end,
            {
                tag="text",
                Cross=true,
                height="full", padding=5,
                font_size=16, font_color=ui.color:rgb(255,255,255),
                align="left", valign="center", textalign="middle",
                text="橡皮设置",
            }
        },
        {
            tag="frame",
            width="full", height="fill",
            {
                tag="frame",
                width="full", height=30,
                {
                    tag="text",
                    text="宽度",
                },
                {
                    id="wb_eraser_width",
                    tag="sliderbar",
                    margin=5,
                    width="fill", height=30,
                    region_color=ui.color:rgb(233,233,233),
                    range_color=ui.color:rgb(73,110,243),
                    slider_color=ui.color:rgb(240,240,240),
                    range_begin=1, range_end=100,
                    value=3,
                    OnDragStart=function(this,x,y,zDelta)
                        window:PopupCallBack("wbconfig",{
                            wb_eraser_width=tonumber(window.body:getid("wb_eraser_width").value),
                            wb_eraser_alpha=tonumber(window.body:getid("wb_eraser_alpha").value)
                        })
                    end,
                    OnDragMove=function(this,x,y,zDelta)
                        window:PopupCallBack("wbconfig",{
                            wb_eraser_width=tonumber(window.body:getid("wb_eraser_width").value),
                            wb_eraser_alpha=tonumber(window.body:getid("wb_eraser_alpha").value)
                        })
                    end,
                    OnMouseWheel=function(this,x,y,zDelta)
                        local val = tonumber(this.value)
                        val = math.tointeger(val + 1 * zDelta/120)
                        this.value = val
                        window:PopupCallBack("wbconfig",{
                            wb_eraser_width=tonumber(window.body:getid("wb_eraser_width").value),
                            wb_eraser_alpha=tonumber(window.body:getid("wb_eraser_alpha").value)
                        })
                    end,
                },
            },
            {
                tag="frame",
                width="full", height=30,
                {
                    tag="text",
                    text="不透明度",
                },
                {
                    id="wb_eraser_alpha",
                    tag="sliderbar",
                    margin=5,
                    width="fill", height=30,
                    region_color=ui.color:rgb(233,233,233),
                    range_color=ui.color:rgb(73,110,243),
                    slider_color=ui.color:rgb(240,240,240),
                    range_begin=1, range_end=255,
                    value=255,
                    OnDragStart=function(this,x,y,zDelta)
                        window:PopupCallBack("wbconfig",{
                            wb_eraser_width=tonumber(window.body:getid("wb_eraser_width").value),
                            wb_eraser_alpha=tonumber(window.body:getid("wb_eraser_alpha").value)
                        })
                    end,
                    OnDragMove=function(this,x,y,zDelta)
                        window:PopupCallBack("wbconfig",{
                            wb_eraser_width=tonumber(window.body:getid("wb_eraser_width").value),
                            wb_eraser_alpha=tonumber(window.body:getid("wb_eraser_alpha").value)
                        })
                    end,
                    OnMouseWheel=function(this,x,y,zDelta)
                        local val = tonumber(this.value)
                        val = math.tointeger(val + 1 * zDelta/120)
                        this.value = val
                        window:PopupCallBack("wbconfig",{
                            wb_eraser_width=tonumber(window.body:getid("wb_eraser_width").value),
                            wb_eraser_alpha=tonumber(window.body:getid("wb_eraser_alpha").value)
                        })
                    end,
                },
            }
        }
    }
}
local popwin_zoom_config = {
    title="缩放",
    --resizeable=false,
    oncreate=function(this)
        window:HideTitle(true)
        window:SetWindowMinSize(0,0)
        window:setclientsize(110,100)
    end,
    OnActive=function(this,bActive,bInProcess)
        if true==bActive then
            window.body[1].background_color=window.color
        else
            window:Close()
        end
    end,
    OnKeyUp=function(this,ch)
        if ch==0x1B then
            this:Close()
        end
    end,
    -------------------------------------------------------------------------------
    body = {
        {
            tag="text",
            width="full", height=0.2,
            font_size=14, font_color=ui.color:rgb(0,0,0),
            align="left", valign="center", textalign="middle",
            text="按屏幕大小缩放",
        },
        {
            tag="text",
            width="full", height=0.2,
            font_size=14, font_color=ui.color:rgb(0,0,0),
            align="left", valign="center", textalign="middle",
            text="100%",
        },
        {
            tag="text",
            width="full", height=0.2,
            font_size=14, font_color=ui.color:rgb(0,0,0),
            align="left", valign="center", textalign="middle",
            text="200%",
        },
        {
            tag="text",
            width="full", height=0.2,
            font_size=14, font_color=ui.color:rgb(0,0,0),
            align="left", valign="center", textalign="middle",
            text="放大",
        },
        {
            tag="text",
            width="full", height=0.2,
            font_size=14, font_color=ui.color:rgb(0,0,0),
            align="left", valign="center", textalign="middle",
            text="缩小",
        },
    }
}
local popwin_colorpalette_config = {
    title="调色板",
    resizeable=false,
    oncreate=function(this)
        window:HideTitle(true)
        window:SetWindowMinSize(0,0)
        window:setclientsize(400,275)
    end,
    OnActive=function(this,bActive,bInProcess)
        if true==bActive then
            window.body[1].background_color=window.color
        else
            window:Close()
        end
    end,
    OnKeyUp=function(this,ch)
        if ch==0x1B then
            this:Close()
        end
    end,
    -------------------------------------------------------------------------------
    body = {
        --background_color=ui.color:rgb(255,255,255),
        --border=4,
        align="center", valign="top", textalign="center",
        Cross=true,
        OnMessage=function(this,message,param)
            local hsv = ui.color:hsvtab(param)
            local rgb = ui.color:rgbtab(param)
            if not(message=="colorbar") then
                window.body:getid("colorbar").h = hsv.h
            end
            if message=="huebar" then
                window.body:getid("colorbar").h = window.body:getid("huebar").h
                window.body:getid("colorbar"):refresh()
            end
            window.body:getid("colorbar").s = hsv.s
            window.body:getid("colorbar").v = hsv.v
            window.body:getid("colorbar").color=param
            if message=="init" or message=="rgb" then
                window.body:getid("huebar").h = hsv.h
            end
            window.body:getid("huebar").s = hsv.s
            window.body:getid("huebar").v = hsv.v
            window.body:getid("huebar").color=param
            window.body:getid("color").background_color=param
            if not(message=="rgb") then
                window.body:getid("color_r").value=tostring(rgb.r)
                window.body:getid("color_g").value=tostring(rgb.g)
                window.body:getid("color_b").value=tostring(rgb.b)
            end
        end,
        {
            tag="frame",
            width="full", height=35,
            background_color=window.color,
            OnLeftMouseDown=function(this,x,y,zDelta)
                window:StartMove()
            end,
            {
                tag="text",
                Cross=true,
                height="full", padding=5,
                font_size=16, font_color=ui.color:rgb(255,255,255),
                align="left", valign="center", textalign="middle",
                text="拾色器",
            }
        },
        {
            tag="frame",
            id="colorbar",
            width="full", height=200,
            OnDragMove=function(this,x,y,zDelta)
                this.OnLeftMouseClick(this,x,y,zDelta)
            end,
            OnLeftMouseClick=function(this,x,y,zDelta)
                local rt = this.rect
                local w,h = rt[3]-rt[1],rt[4]-rt[2]
                local _x,_y = x-rt[1],y-rt[2]
                local _color = ui.color:hsv(this.h,_x/w,1-_y/h)
                window.body.OnMessage(window.body,"colorbar",_color)
                window:PopupCallBack("pickcolor",_color)
            end,
            OnPaint=function(this,surface,w,h)
                local c = ui.color:hsv(this.h,1,1)
                local ix = w*this.s
                local iy = h*(1-this.v)
                surface:clear(0)
                surface.Style="fill"
                surface:drawColorBar(c)
                surface.Style="border"
                surface.StrokeWidth=1
                if (this.s+(1-this.v))>0.4 then
                    surface.color=ui.color:rgb(255,255,255)
                else
                    surface.color=ui.color:rgb(0,0,0)
                end
                surface:drawCircle(ix,iy,6)
                return true
            end,
        },
        { tag="space", width="full", height=2 },
        {
            tag="frame",
            id="huebar",
            h=0,
            width="fill",height=30,
            OnDragMove=function(this,x,y,zDelta)
                this.OnLeftMouseClick(this,x,y,zDelta)
            end,
            OnLeftMouseClick=function(this,x,y,zDelta)
                local rt = this.rect
                local _x,_y = x-rt[1],math.ceil((rt[4]-rt[2])/2)
                this.h = _x/(rt[3]-rt[1]);
                this:refresh()
                local _color = ui.color:hsv(this.h,this.s,this.v)
                window.body.OnMessage(window.body,"huebar",_color)
                window:PopupCallBack("pickcolor",_color)
            end,
            OnPaint=function(this,surface,w,h)
                local ix = w*this.h
                surface:clear(0)
                surface.AntiAlias=true
                surface.Style="fill"
                surface:drawHueBar()
                surface.color=ui.color:rgb(255,255,255,255)
                surface:drawRect(ix-5,0,ix+5,5)
                surface:drawRect(ix-5,h-5,ix+5,h)
                return true
            end,
        },
        { tag="space", width="full", height=2 },
        {
            tag="frame",
            width="full", height="fill",
            height_keep=2,
            align="center", valign="center", textalign="center",
            Cross=true,
            { tag="space", width=2, height="full" },
            {
                tag="frame",
                id="color",
                width=80,height="full",
                border=1, border_color=ui.color:rgb(128,128,128,128),
            },
            { tag="space", width=2, height="full" },
            {
                tag="frame",
                width="fill", height="full",
                align="center", valign="center", textalign="center",
                Cross=true,
                OnMessage=function(this,message,param)
                    local r = tonumber(window.body:getid("color_r").value)
                    local g = tonumber(window.body:getid("color_g").value)
                    local b = tonumber(window.body:getid("color_b").value)
                    local _color = ui.color:rgb(r,g,b)
                    window.body.OnMessage(window.body,"rgb",_color)
                    window:PopupCallBack("pickcolor",_color)
                end,
                {
                    tag="text",
                    width=40,height="full",
                    align="center", valign="center", textalign="center",
                    font_size=24,
                    text="红:",
                },
                {
                    tag="input",
                    id="color_r",
                    width=60,height="full",
                    align="center", valign="center", textalign="center",
                    font_size=24,
                    value="0",
                    OnMouseWheel=function(this,x,y,zDelta)
                        local val = tonumber(this.value)
                        val = math.tointeger(val + 1 * zDelta/120)
                        if val<0 then val=0 end
                        if val>255 then val=255 end
                        this.value = tostring(val)
                        this.parent.OnMessage(this.parent,"scroll")
                    end,
                },
                {
                    tag="text",
                    width=40,height="full",
                    align="center", valign="center", textalign="center",
                    font_size=24,
                    text="绿:",
                },
                {
                    tag="input",
                    id="color_g",
                    width=60,height="full",
                    align="center", valign="center", textalign="center",
                    font_size=24,
                    value="0",
                    OnMouseWheel=function(this,x,y,zDelta)
                        local val = tonumber(this.value)
                        val = math.tointeger(val + 1 * zDelta/120)
                        if val<0 then val=0 end
                        if val>255 then val=255 end
                        this.value = tostring(val)
                        this.parent.OnMessage(this.parent,"scroll")
                    end,
                },
                {
                    tag="text",
                    width=40,height="full",
                    align="center", valign="center", textalign="center",
                    font_size=24,
                    text="蓝:",
                },
                {
                    tag="input",
                    id="color_b",
                    width=60,height="full",
                    align="center", valign="center", textalign="center",
                    font_size=24,
                    value="0",
                    OnMouseWheel=function(this,x,y,zDelta)
                        local val = tonumber(this.value)
                        val = math.tointeger(val + 1 * zDelta/120)
                        if val<0 then val=0 end
                        if val>255 then val=255 end
                        this.value = tostring(val)
                        this.parent.OnMessage(this.parent,"scroll")
                    end,
                }
            }
        }
    }
}
local M = {
    tag="frame",
    width="full", height="full",
    align="center", valign="center", textalign="center",
    background_color=ui.color:rgb(128,128,128),
    OnKeyUp=function(this,ch,flag)
    end,
    OnKeyDown=function(this,ch,flag)
        --dump(ch)
        local toolbtn = nil
        --非工具按钮部分
        if ch==0x5A and flag.ctrl==true and flag.shift==false and flag.alt==false then
            --Ctrl+'Z' --撤销
            return
        end
        if ch==0x59 and flag.ctrl==true and flag.shift==false and flag.alt==false then
            --Ctrl+'Y' --重做
            return
        end
        if ch==0x30 and flag.ctrl==true and flag.shift==false and flag.alt==false then
            --Ctrl+'0' --缩放100%
            return
        end
        if ch==0xBB and flag.ctrl==true and flag.shift==false and flag.alt==false then
            --Ctrl+'+' --缩放-放大
            return
        end
        if ch==0xBD and flag.ctrl==true and flag.shift==false and flag.alt==false then
            --Ctrl+'-' --缩放-缩小
            return
        end
        --工具按钮部分
        if ch==0x20 and flag.ctrl==false and flag.shift==false and flag.alt==false then
            toolbtn = window.body:getid("wbtool_move")
        end
        if ch==0x48 and flag.ctrl==false and flag.shift==false and flag.alt==false then
            toolbtn = window.body:getid("wbtool_move")
        end
        if ch==0x42 and flag.ctrl==false and flag.shift==false and flag.alt==false then
            --键盘(B)
            toolbtn = window.body:getid("wbtool_brush")
        end
        if ch==0x53 and flag.ctrl==false and flag.shift==false and flag.alt==false then
            --键盘(S)
            toolbtn = window.body:getid("wbtool_sharp")
        end
        if ch==0x45 and flag.ctrl==false and flag.shift==false and flag.alt==false then
            --键盘(E)
            toolbtn = window.body:getid("wbtool_eraser")
        end
        if toolbtn then
            if toolbtn.OnLeftMouseClick then
                toolbtn.OnLeftMouseClick(toolbtn,1,1,0)
            end
        end
    end,
    OnMessage=function(this,message,param)
        local wb = this:getitem("wb",1,2)
        if message=="wb_forecolor" then
            local wbb_zone = this:getitem("wb_forecolor")
            wbb_zone.background_color = param
            wb.wb_forecolor=param
            return
        end
        if message=="wb_backcolor" then
            local wbb_zone = this:getitem("wb_backcolor")
            wbb_zone.background_color = param
            wb.wb_backcolor=param
            return
        end
        if message=="wb_tool" then
            wb.wb_tool = param
        end
        if message=="open" or message=="save" or message=="new" or message=="close" then
            wb:Exec(message,param)
        end
    end,
    {--绘图工具栏
        tag="frame",
        item="tool_list",
        -- position="absolute",
        -- posalign="lt", x=0, y=0,
        width=41, height="full",
        align="center", valign="top", textalign="center",
        background_color=ui.color:rgb(220,220,220),
        border_right_width=1,
        border_color=ui.color:rgb(128,128,128,128),
        Styles.tool_split,
        {
            tag="frame",
            item="toolicon",
            id="wbtool_new",
            toolname="new",
            CrossChilds=true,
            class=Styles.toolicon_nofocus,
            OnMouseOver=Styles.toolicon_nofocus.OnMouseOver,
            OnMouseOut=Styles.toolicon_nofocus.OnMouseOut,
            OnLeftMouseClick=function(this,x,y,zDelta)
                Styles.toolicon_nofocus.OnLeftMouseClick(this,x,y,zDelta)
                local wb = this.parent.parent:getitem("wb",1,2)
                wb:Exec("new")
            end,
            OnLeftMouseDown=Styles.toolicon_nofocus.OnLeftMouseDown,
            OnLeftMouseUp=Styles.toolicon_nofocus.OnLeftMouseUp,
            { tag="image", src="${appdir}/wb_new.png", }
    
        },
        Styles.tool_split,
        {
            tag="frame",
            item="toolicon",
            id="wbtool_open",
            toolname="open",
            CrossChilds=true,
            class=Styles.toolicon_nofocus,
            OnMouseOver=Styles.toolicon_nofocus.OnMouseOver,
            OnMouseOut=Styles.toolicon_nofocus.OnMouseOut,
            OnLeftMouseClick=function(this,x,y,zDelta)
                Styles.toolicon_nofocus.OnLeftMouseClick(this,x,y,zDelta)
                local wb = this.parent.parent:getitem("wb",1,2)
                local ret,filepath = window:OpenFileDialog(
                    "打开文件",
                    "Png文件(*.png),*.png,Bmp文件(*.bmp),*.bmp,"..
                    "Ico文件(*.ico),*.ico,所有文件(*.*),*.*"
                );
                if ret==true then
                    wb:Exec("open",filepath)
                end
            end,
            OnLeftMouseDown=Styles.toolicon_nofocus.OnLeftMouseDown,
            OnLeftMouseUp=Styles.toolicon_nofocus.OnLeftMouseUp,
            { tag="image", src="${appdir}/wb_open.png", }
    
        },
        Styles.tool_split,
        {
            tag="frame",
            item="toolicon",
            id="wbtool_save",
            toolname="save",
            CrossChilds=true,
            class=Styles.toolicon_nofocus,
            OnMouseOver=Styles.toolicon_nofocus.OnMouseOver,
            OnMouseOut=Styles.toolicon_nofocus.OnMouseOut,
            OnLeftMouseClick=function(this,x,y,zDelta)
                Styles.toolicon_nofocus.OnLeftMouseClick(this,x,y,zDelta)
                local wb = this.parent.parent:getitem("wb",1,2)
                local ret,filepath = window:SaveFileDialog(wb.curfile,
                    "保存文件",
                    "Png文件(*.png),*.png,Bmp文件(*.bmp),*.bmp,"..
                    "Ico文件(*.ico),*.ico,所有文件(*.*),*.*"
                );
                if ret==true then
                    wb:Exec("save",filepath)
                end
            end,
            OnLeftMouseDown=Styles.toolicon_nofocus.OnLeftMouseDown,
            OnLeftMouseUp=Styles.toolicon_nofocus.OnLeftMouseUp,
            { tag="image", src="${appdir}/wb_save.png", }
    
        },
        Styles.tool_split,
        {
            tag="frame",
            item="toolicon",
            id="wbtool_close",
            toolname="close",
            CrossChilds=true,
            class=Styles.toolicon_nofocus,
            OnMouseOver=Styles.toolicon_nofocus.OnMouseOver,
            OnMouseOut=Styles.toolicon_nofocus.OnMouseOut,
            OnLeftMouseClick=function(this,x,y,zDelta)
                Styles.toolicon_nofocus.OnLeftMouseClick(this,x,y,zDelta)
                local wb = this.parent.parent:getitem("wb",1,2)
                wb:Exec("close")
            end,
            OnLeftMouseDown=Styles.toolicon_nofocus.OnLeftMouseDown,
            OnLeftMouseUp=Styles.toolicon_nofocus.OnLeftMouseUp,
            { tag="image", src="${appdir}/wb_close.png", }
    
        },
        Styles.tool_split,
        Styles.tool_split_dark,
        Styles.tool_split,
        {
            tag="frame",
            item="toolicon",
            id="wbtool_resize",
            toolname="resize",
            CrossChilds=true,
            class=Styles.toolicon_nofocus,
            OnMouseOver=Styles.toolicon_nofocus.OnMouseOver,
            OnMouseOut=Styles.toolicon_nofocus.OnMouseOut,
            OnLeftMouseClick=function(this,x,y,zDelta)
                Styles.toolicon_nofocus.OnLeftMouseClick(this,x,y,zDelta)
                local wb = this.parent.parent:getitem("wb",1,2)
                local rt = window.WindowRect
                local pt = { x=x+rt[1], y=y+rt[2] }
                local pwin = window:PopupOpen(popwin_resize_config,wb)
                pwin:Move(pt.x,pt.y)
                pwin.body.OnMessage(pwin.body,"init",{
                    width=wb.wb_width,height=wb.wb_height,
                    x=wb.wb_x,y=wb.wb_y
                })
            end,
            OnLeftMouseDown=Styles.toolicon_nofocus.OnLeftMouseDown,
            OnLeftMouseUp=Styles.toolicon_nofocus.OnLeftMouseUp,
            { tag="image", src="${appdir}/wb_resize.png", }
    
        },
        Styles.tool_split,
        {
            tag="frame",
            item="toolicon",
            id="wbtool_move",
            toolname="move",
            CrossChilds=true,
            class=Styles.toolicon,
            OnMouseOver=Styles.toolicon.OnMouseOver,
            OnMouseOut=Styles.toolicon.OnMouseOut,
            OnLeftMouseClick=Styles.toolicon.OnLeftMouseClick,
            { tag="image", src="${appdir}/wb_move.png", }
    
        },
        Styles.tool_split,
        Styles.tool_split_dark,
        Styles.tool_split,
        {
            tag="frame",
            item="toolicon",
            id="wbtool_clear",
            toolname="clear",
            CrossChilds=true,
            class=Styles.toolicon_nofocus,
            OnMouseOver=Styles.toolicon_nofocus.OnMouseOver,
            OnMouseOut=Styles.toolicon_nofocus.OnMouseOut,
            OnLeftMouseClick=Styles.toolicon_nofocus.OnLeftMouseClick,
            OnLeftMouseDown=Styles.toolicon_nofocus.OnLeftMouseDown,
            OnLeftMouseUp=Styles.toolicon_nofocus.OnLeftMouseUp,
            { tag="image", src="${appdir}/wb_clear.png", }
    
        },
        Styles.tool_split,
        {
            tag="frame",
            item="toolicon",
            id="wbtool_brush",
            toolname="brush",
            CrossChilds=true,
            class=Styles.toolicon,
            OnMouseOver=Styles.toolicon.OnMouseOver,
            OnMouseOut=Styles.toolicon.OnMouseOut,
            OnLeftMouseClick=Styles.toolicon.OnLeftMouseClick,
            { tag="image", src="${appdir}/wb_brush.png", }
    
        },
        Styles.tool_split,
        {
            tag="frame",
            item="toolicon",
            id="wbtool_sharp",
            toolname="sharp",
            CrossChilds=true,
            class=Styles.toolicon,
            OnMouseOver=Styles.toolicon.OnMouseOver,
            OnMouseOut=Styles.toolicon.OnMouseOut,
            OnLeftMouseClick=Styles.toolicon.OnLeftMouseClick,
            { tag="image", src="${appdir}/wb_sharp.png", }
    
        },
        Styles.tool_split,
        {
            tag="frame",
            item="toolicon",
            id="wbtool_eraser",
            toolname="eraser",
            CrossChilds=true,
            class=Styles.toolicon,
            OnMouseOver=Styles.toolicon.OnMouseOver,
            OnMouseOut=Styles.toolicon.OnMouseOut,
            OnLeftMouseClick=Styles.toolicon.OnLeftMouseClick,
            { tag="image", src="${appdir}/wb_eraser.png", }
    
        },
        Styles.tool_split,
        {
            tag="frame",
            item="toolicon",
            id="wbtool_pick",
            toolname="pick",
            CrossChilds=true,
            class=Styles.toolicon,
            OnMouseOver=Styles.toolicon.OnMouseOver,
            OnMouseOut=Styles.toolicon.OnMouseOut,
            OnLeftMouseClick=Styles.toolicon.OnLeftMouseClick,
            { tag="image", src="${appdir}/wb_pick.png", }
    
        },
        Styles.tool_split,
        {
            tag="frame",
            item="toolicon",
            id="wbtool_zoom",
            toolname="zoom",
            CrossChilds=true,
            class=Styles.toolicon,
            OnMouseOver=Styles.toolicon.OnMouseOver,
            OnMouseOut=Styles.toolicon.OnMouseOut,
            OnLeftMouseClick=Styles.toolicon.OnLeftMouseClick,
            { tag="image", src="${appdir}/wb_zoom.png", }
        },
        Styles.tool_split,
        {
            tag="frame",
            item="toolicon",
            toolname="color",
            class=Styles.toolicon_nofocus,
            OnMessage=function(this,message,param)
                if this.parent.parent.OnMessage then
                    this.parent.parent.OnMessage(this.parent.parent,message,param)
                end
            end,
            {
                tag="frame", --背景色
                id="wbtool_backcolor",
                position="absolute",
                posalign="rb",
                width=24,height=24,
                border=1, border_color=ui.color:rgb(0,0,0),
                OnMessage=function(this,message,param)
                    if this.parent.OnMessage then
                        this.parent.OnMessage(this.parent,message,param)
                    end
                end,
                OnLeftMouseClick=function(this,x,y,zDelta)
                    local rt = window.WindowRect
                    local pt = { x=x+rt[1], y=y+rt[2]}
                    local pwin = window:PopupOpen(popwin_colorpalette_config,this)
                    pwin:Move(pt.x,pt.y)
                    pwin.body.OnMessage(pwin.body,"init",this[1].background_color)
                end,
                OnPopupCallback=function(this,message,param)
                    if message=="pickcolor" then
                        this.OnMessage(this,"wb_backcolor",param)
                    end
                end,
                {
                    tag="frame",
                    Cross=true,
                    item="wb_backcolor",
                    width="full",height="full",
                    background_color=ui.color:rgb(255,255,255),
                    border=1, border_color=ui.color:rgb(255,255,255),
                }
            },
            {
                tag="frame", --前景色
                id="wbtool_forecolor",
                position="absolute",
                posalign="lt",
                width=24,height=24,
                --background_color=ui.color:rgb(255,0,0),
                border=1, border_color=ui.color:rgb(0,0,0),
                OnMessage=function(this,message,param)
                    if this.parent.OnMessage then
                        this.parent.OnMessage(this.parent,message,param)
                    end
                end,
                OnLeftMouseClick=function(this,x,y,zDelta)
                    local rt = window.WindowRect
                    local pt = { x=x+rt[1], y=y+rt[2]}
                    local pwin = window:PopupOpen(popwin_colorpalette_config,this)
                    pwin:Move(pt.x,pt.y)
                    pwin.body.OnMessage(pwin.body,"init",this[1].background_color)
                end,
                OnPopupCallback=function(this,message,param)
                    if message=="pickcolor" then
                        this.OnMessage(this,"wb_forecolor",param)
                    end
                end,
                {
                    tag="frame",
                    Cross=true,
                    item="wb_forecolor",
                    width="full",height="full",
                    background_color=ui.color:rgb(0,0,0),
                    border=1, border_color=ui.color:rgb(255,255,255),
                }
            },
        },
        Styles.tool_split,
    },
    {-- 白板
        tag="whiteboard",
        item="wb",
        width="fill", height="full",
        width_keep=300,
        align="center", valign="top", textalign="center",
        background_color=ui.color:rgb(38,38,38),
        wb_background_color=ui.color:rgb(255,255,255),
        OnInit=function(this)
            --this.wb_width=1920
            --this.wb_height=1080
            --this.wb_backcolor=ui.color:rgb(100,100,240)
            --this.wb_forecolor=ui.color:rgb(255,100,120)
            this.wb_brush_mode=4
            this.wb_brush_width=3
            this.wb_brush_alpha=255
            this.wb_eraser_width=5
            this.wb_eraser_alpha=255
            local tt = window.body:getid("wbtool_backcolor")
            if tt then
                tt:getitem("wb_backcolor").background_color = this.wb_backcolor
            end
            tt = window.body:getid("wbtool_forecolor")
            if tt then
               tt:getitem("wb_forecolor").background_color = this.wb_forecolor 
            end
            -- local td = this.parent:getitem("tool_detail")
            -- if td then
            --     this.width_keep = td.width
            -- end
        end,
        OnLeftMouseClick=function(this,x,y,zDelta)
            local curtool = this.wb_tool
            if curtool=="pick" then
                local rt = this.rect
                local _x,_y = x-rt[1],y-rt[2]
                local _color = this:getcolor(_x,_y)
                this.parent.OnMessage(this.parent,"wb_forecolor",_color)
                this:refresh()
                return
            end
        end,
        OnRightMouseClick=function(this,x,y,zDelta)
            local curtool = this.wb_tool
            if curtool=="pick" then
                local rt = this.rect
                local _x,_y = x-rt[1],y-rt[2]
                local _color = this:getcolor(_x,_y)
                this.parent.OnMessage(this.parent,"wb_backcolor",_color)
                return
            end
            -----------------------------------
            local pwinConfig
            local pwinInit = {}
            if curtool=="brush" then
                pwinConfig = popwin_brush_config
                pwinInit = {
                    wb_brush_width=this.wb_brush_width,
                    wb_brush_alpha=this.wb_brush_alpha
                }
            end
            if curtool=="eraser" then
                pwinConfig = popwin_eraser_config
                pwinInit = {
                    wb_eraser_width=this.wb_eraser_width,
                    wb_eraser_alpha=this.wb_eraser_alpha
                }
            end
            if curtool=="zoom" then
                pwinConfig = popwin_zoom_config
            end
            if pwinConfig==nil then return end
            -----------------------------------
            local rt = window.WindowRect
            local pt = { x=x+rt[1], y=y+rt[2]}
            local pwin = window:PopupOpen(pwinConfig,this)
            pwin:Move(pt.x,pt.y)
            if pwin.body.OnMessage then
                pwin.body.OnMessage(pwin.body,"init",pwinInit)
            end
        end,
        OnPopupCallback=function(this,message,param)
            if message=="wbconfig" then
                for k,v in pairs(param) do
                    this[k] = v
                end
            end
        end,
    },
    {--绘图工具栏
        tag="frame",
        item="tool_detail",
        -- position="absolute",
        -- posalign="lt", x=0, y=0,
        width="fill", height="full",
        align="center", valign="top", textalign="center",
        background_color=ui.color:rgb(220,220,220),
        border_left_width=1,
        border_color=ui.color:rgb(128,128,128,128),
        Styles.tool_panel_split,
        {
            tag="frame",
            width="full", height=200,
            {
                tag="frame",
                width="full", height="auto",
                background_color=ui.color:rgb(128,128,128),
                align="top", valign="top", textalign="center",
                {
                    tag="text",
                    padding=3,
                    font_color=ui.color:rgb(240,240,240),
                    text="色板",
                }
            },
        },
        Styles.tool_panel_split,
        {
            tag="frame",
            width="full", height=200,
            {
                tag="frame",
                width="full", height="auto",
                background_color=ui.color:rgb(128,128,128),
                align="top", valign="top", textalign="center",
                {
                    tag="text",
                    padding=3,
                    font_color=ui.color:rgb(240,240,240),
                    text="笔刷",
                }
            },
        },
        Styles.tool_panel_split,
        {
            tag="frame",
            width="full", height="fill",
            {
                tag="frame",
                width="full", height="auto",
                background_color=ui.color:rgb(128,128,128),
                align="top", valign="top", textalign="center",
                {
                    tag="text",
                    padding=3,
                    font_color=ui.color:rgb(240,240,240),
                    text="图层",
                }
            },
        },
    }
}
return M