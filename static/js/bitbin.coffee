$ = require 'jquery'

getBin = (bin_id) ->

    # Get bin.json
    $.ajax
        url: "http://bitbin.io/#{bin_id}.json"
        xhrFields: withCredentials: true
    .done (data) ->
        console.log data

        # Need to pay
        if data.pay?

            # Show pay iframe
            $(".article##{bin_id} .content").html(data.pay.embed_code)

            # Reload the page with message posted from iframe
            window.addEventListener 'message', (m) ->
                if m.data == 'reload'
                    location.reload()

        # Can download
        else if data.download?

            if data.download.payload.kind == 'text'

                # Download text content
                options =
                $.ajax
                    url: data.download.download_link
                    xhrFields: withCredentials: true
                .done (content) ->

                    # Render in text content
                    $(".article##{bin_id} .content").html(content)

            # Show download iframe
            else
                $(".article##{bin_id} .content").html(data.download.embed_code)

bin_ids.map getBin
