function Chinese()
    hs.keycodes.currentSourceID("com.sogou.inputmethod.sogou.pinyin")
end

function English()
    hs.keycodes.currentSourceID("com.apple.keylayout.US")
end


function myprint(x)
    hs.console.printStyledtext(x)
end