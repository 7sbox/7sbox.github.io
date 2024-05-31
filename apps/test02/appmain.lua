return {
    tag="frame",
    width="full", height="full",
    background_color=ui.color:rgb(0,0,0),
    {
        tag="webview2",
        visible=true,
        width="full", height="full",
        url="https://www.bilibili.com/",
        OnMessage=function(this,message)
            --msg(message)
        end,
        OnLeftMouseClick=function(this,x,y,zDelta)
            window.body:getid("webview01"):Exec(
            	"window.location.href",
            	function(this,message)
            		msg(message)
            	end
            )
        end,
    }
}