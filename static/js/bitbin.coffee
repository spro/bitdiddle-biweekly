$ = require 'jquery'

# Get helper for ajax passing session

getWithCredentials = (url, cb) ->
    $.ajax
        url: url
        xhrFields: withCredentials: true
    .done cb

# Get a bin's pay or download data

getBinData = (bin_id, cb) ->

    # Get bin.json
    getWithCredentials "http://bitbin.io/#{bin_id}.json", (data) ->
        console.log data

        # Need to pay
        if data.pay?
            cb null, data.pay, null

        # Can download
        else if data.download?
            cb null, null, data.download

# Show a bin iframe for each div#data-bin-id=*

showBinIframes = ->
    $bin_divs = $("[data-bin-id]")
    $bin_divs.map ->
        $bin_div = $(@)
        bin_id = $bin_div.data('bin-id')
        showBinIframe bin_id, $bin_div

# Get a bin and render into an iframe

showBinIframe = (bin_id, $bin_div, options={}) ->
    if !($bin_div instanceof $)
        $bin_div = $("[data-bin-id=#{bin_id}]")
    getBinData bin_id, (err, pay, download) ->

        if pay?
            renderPayIframe bin_id, $bin_div, pay, options

        else if download?
            renderDownloadIframe bin_id, $bin_div, download, options

renderPayIframe = (bin_id, $bin_div, pay, options={}) ->
    # Show pay iframe
    console.log $bin_div
    $bin_div.html(pay.embed_code)

    # Reload the page with message posted from iframe
    window.addEventListener 'message', (m) ->
        if m.data == 'reload'
            location.reload()

renderDownloadIframe = (bin_id, $bin_div, download, options={}) ->

    # Show download text
    if download.payload.kind == 'text' && !options.always_iframe

        # Get raw text
        getWithCredentials download.download_link, (content) ->

            # Render in content
            $bin_div.html(content)

    # Show download iframe
    else
        $bin_div.html(download.embed_code)

showBinIframes()
#bin_ids.map showBinIframe
#bin_ids.map (bin_id) -> showBinIframe bin_id, $(".article##{bin_id} .content")
