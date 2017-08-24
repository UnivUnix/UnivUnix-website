# DocPad Configuration File
# http://docpad.org/docs/config
environment = require('./environment.json')
mongoose = require('mongoose')

# Define the DocPad Configuration
docpadConfig = {
  regenerateDelay: 1000
  ignoreHiddenFiles: true

  port: 9778
  checkVersion: true

  templateData:
    site:
      url: "http://univunix.com"
      title: "UnivUnix"
      description: """
        El portal unificado de Unix, sus derivados y el software libre.
        Ahora con temas mas allá del software.
        """
      keywords: """
        Unix, GNU, Linux, Mac, BSD, software, libre, electrónica, impresión, 3D
        """
    # Helper functions
    getDocumentTitle: ->
      if @document.title
        "#{@document.title} | #{@site.title}"
      else
        @site.title

    getDocumentDescription: ->
      @document.description or @site.description

    getKeywords: ->
      @site.keywords.concat(@document.keywords or []).join(', ')

    formatURL: (url) ->
      url
      .replace(/\s/g, "%20")
      .replace(/&/g, "&amp;")

    getFullURL: (relativeURL) ->
      @formatURL(@site.url + relativeURL)

  collections:
    articles: ->
      @getCollection("documents").findAllLive({
          relativeOutDirPath: /articles\/*/,
          isPagedAuto: $ne: true
        }, [{date: -1}]).on "add", (model) ->
          model.setMetaDefaults({layout: "article"})

    pages: ->
      @getCollection("documents").findAllLive({
          relativeOutDirPath: "pages",
          isPagedAuto: $ne: true
        }, [{date: -1}]).on "add", (model) ->
          model.setMetaDefaults({layout:"page"})

    categories: ->
      @getCollection("documents").findAllLive({
          relativeOutDirPath: "categories",
          isPagedAuto: $ne: true
        }, [{date: -1}]).on "add", (model) ->
          model.setMetaDefaults({layout: "category",
          isPaged: true,
          pageSize: 8})

    # CATEGORIES
    guides: ->
      @getCollection("articles").findAllLive({
        relativeOutDirPath: /articles\/guides/
        }, [{date: -1}])
  #Environment configuration
  localeCode: 'es'

  environments:
    development:
      templateData:
        site:
          url: "http://localhost:9778"
      hostname: 'localhost'
      maxAge: false
    production:
      maxAge: false
      hostname: 'univunix.com'

  # Plugins configuration
  plugins:
    api:
      cfgSrc: [
        'api/dpaconfig.json'
      ]
    authentication:
      protectedUrls: ['/articles/guides/buenas-practicas-en-nginx-conf']
      forceServerCreation: true

      ensureAuthenticated: (req, res, next) ->
        if req.isAuthenticated()
          return next()
        res.redirect('/login')

      strategies:
        google:
          settings:
            clientID: environment.authentication.google.id
            clientSecret: environment.authentication.google.secret
            authParameters:
              scope: [
                'https://www.googleapis.com/auth/userinfo.profile',
                'https://www.googleapis.com/auth/userinfo.email'
              ]
          url:
            auth: '/auth/google'
            callback: '/auth/google/callback'
            success: '/'
            fail: '/login'
        github:
          settings:
            clientID: environment.authentication.github.id
            clientSecret: environment.authentication.github.secret
          url:
            auth: '/auth/github'
            callback: '/auth/github/callback'
            success: '/'
            fail: '/login'
    imagin:
      imageMagick: true
      targets:
        'articleList': (img, args) ->
          return img
          .resize(698, 396, "^")
          .gravity('Center')
          .crop(698, 396)
        'articleHeader': (img, args) ->
          return img
          .gravity('Center')
          .crop(480, 52)
          .blur(10, 5)
    less:
      referencesOthers: true
      # http://lesscss.org/#using-less-configuration
      lessOptions:
        compress: true,
        sourceMap:
          sourceMapFileInline: true
    marked:
      gfm: true
      tables: true
      breaks: true
      highlight: null
    moment:
      formats: [
        {
          raw: 'date',
          format: 'YYYY-MM-DD',
          formatted: 'pc'
        },
        {
          raw: 'date',
          format: 'DD/MM/YYYY',
          formatted: 'human'
        }
      ]
    paged:
      split: true,
      prefix: 'page'
    related:
      parentCollectionName: 'articles'
    rss:
      default:
        collection: 'articles'

  #Event configuration
  events:

    docpadReady: ->
      docpad = @docpad
      mongoose.connect('mongodb://localhost/univunix', {
        useMongoClient: true
      })
      db = mongoose.connection
      db.once('open', () ->
        docpad.log('info', 'Connected to MongoDB database.')
      )

    docpadDestroy: ->
      docpad = @docpad
      mongoose.disconnect(()->
        docpad.log('info', 'All MongoDB connections are closed.')
      )

    # Server Extend
    # Used to add our own custom routes to the server before the docpad routes are added
    serverExtend: (opts) ->
      # Extract the server from the options
      {server} = opts
      docpad = @docpad

      # As we are now running in an event,
      # ensure we are using the latest copy of the docpad configuraiton
      # and fetch our urls from it
      latestConfig = docpad.getConfig()
      oldUrls = latestConfig.templateData.site.oldUrls or []
      newUrl = latestConfig.templateData.site.url

      # Redirect any requests accessing one of our
      # sites oldUrls to the new site url
      server.use (req,res,next) ->
        if req.headers.host in oldUrls
          res.redirect(newUrl+req.url, 301)
        else
          next()

      server.get '/' , (req,res,next) ->
        if req.user and req.user.isNew
          res.redirect('/sign-up')
        else
          next()
}

# Export the DocPad Configuration
module.exports = docpadConfig
