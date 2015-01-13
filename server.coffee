polar = require 'polar'
request = require 'request'

app = polar.setup_app
    port: 8726
    use_sessions: true
    session_secret: 'adfjkasdfklmasdf'
    metaserve: compilers:
        'css\/(.*)\.css': [
            require('metaserve/src/compilers/raw/bouncer')
                base_dir: './static/css'
                ext: 'bounced.css'
            require('metaserve/src/compilers/css/styl')()
        ]
        'js\/(.*)\.js': [
            require('metaserve/src/compilers/raw/bouncer')
                base_dir: './static/js'
                ext: 'bounced.js'
            require('metaserve/src/compilers/js/browserify-coffee-jsx')
                ext: 'coffee'
                uglify: false
        ]

articles = [
    title: 'Bitcoin Powered Low-Trust Storage'
    bin_id: '3bc4ef3b5b1ff96cb4c81d602d622cb3'
,
    title: "A Platform for Self-Replicating Web Documents"
    bin_id: "d9fa41a716b3ae6825b65eddd51fd1ac"
,
    title: 'Swarm Economics Thesis'
    bin_id: 'c7d46e8affde7af5b930050ed170552e'
,
    title: "Before You Say The Economy Is Better, Listen To This One Question From A Bitcoin Developer"
    bin_id: '6c35e7ce296c742cab55dbe13c25582b'
,
    title: "What Happens When One Trailblazing Cryptographer Gets Real About The Biggest Problem In America."
    bin_id: '1840e44c5cb9b5690f56954e81f0fcab'
]

app.get '/', (req, res) ->
    bin_ids = articles.map (a) -> a.bin_id
    res.render 'articles', {articles, bin_ids}

app.start()

