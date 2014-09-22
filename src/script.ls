<-! $(document).ready

fs = require \fs
path = require \path
# spawn = require \child_process .spawn 
spawn = require \cross-spawn .spawn 

ext_imgs = [\.jpg, \.gif, \.png, \.PNG]
content = $ \#content
input = $ \#input
prefix = $ \.ok
preview = $ '#preview'


command = commandDefault

function updateInput path
    levels = path / "\\"
    oldwidth = prefix.width!

    prefix .html ""
    for level in levels
        prefix .append '<span class="level">' + level + "</span>"

    prefix.css('width', 'auto')
    newwidth = prefix.width!

    prefix.css('width', oldwidth)
    prefix.animate({width: newwidth}, 100)

    console.log \workingdirectory + process.cwd()


function commandDefault text
    console.log \command_ + text
    content .append '<p class="command">' + text + \</p>

    args = text / " "

    if args[0] == \ls
        files = fs.readdirSync(process.cwd())
        elresult = $ '<p class="result"></p>'
        content .append elresult

        for file in files
            icon_image = "icon_default.png"
            cls = 'class=""'
            ext = path.extname(file)
            prep = false
            if ext == \.html
                icon_image = "icon_html.png"
            else if ext == \.js
                icon_image = "icon_javascript.png"
            else if ext in ext_imgs
                icon_image = "icon_image.png"
            else if ext == ""
                cls = 'class="folder"'
                prep = true

            elem = '<p ' + cls + '><img src="' + icon_image + '">' + file + \</p>
            if prep
                elresult .prepend elem 
            else
                elresult. append elem

        # EVENTS
        $ elresult .on "mouseenter", "p", ->
            preview.clearQueue!
            filename = $(this).text!
            ext = path.extname(filename)

            if ext in ext_imgs
                imagepath = path.join(process.cwd(), filename)
                preview.attr \src imagepath
                preview.css \right, -preview.outerWidth!
                preview.animate {right: 0}, 100

        $ elresult .on "mouseleave", "p", ->
            preview.clearQueue!
            preview.animate {right: -preview.outerWidth!}, 100
            

        # NO FILES IN LS
        if files.length == 0
            elresult .append '<p><img src="icon_sadface.png"></p>'

    else if args[0] == \cd
        process.chdir args[1]
        updateInput process.cwd()

    else
        elresult = $ '<p class="result"></p>' # REFACTOR PLEASE
        content .append elresult

        console.log \command_ + args[0]
        app = spawn args[0]

        app.on \error (error) ->
            console.log \error_ + error

        app.on \exit (exit) ->
            console.log \exit_ + exit

        app.on \close (close) ->
            console.log \close_ + close

        app.on \disconnect (disconnect) ->
            console.log \disconnect_ + disconnect

        app.stdout.on \data, (data) ->
          console.log 'data: ' + data.toString('utf-8')
          # data = data.toString('UCS-2')
          data = data.toString('utf-8')

          lines = data / '\n'
          for line in lines
            elresult. append '<p>' + line + '</p>'

        app.stdout.on \readable, (data) ->
          console.log 'readable: ', data

        app.stderr.on \data, (data) ->
          # console.log 'error: ', data
          console.log 'error: ' + data.toString('utf-8')
          lines = data.toString('utf-8') / '\n'
          for line in lines
            elresult. append '<p>' + line + '</p>'

        app.stdin.on \drain, (data) ->
            console.log "drain " + data

        app.stdin.on \finish, (data) ->
            console.log "finish " + data

        app.stdin.on \pipe, (data) ->
            console.log "pipe " + data

        command := (text) ->
            app.stdin.write(text)
            app.stdin.end();



# command \ok
updateInput process.cwd()

input .keypress ->
    if event.which == 13
        # console.log \ENTER
        command (input .val!)
        input .val ""
        $ "html, body" .animate { scrollTop: $(document).height! }, "slow"
