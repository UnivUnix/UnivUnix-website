# DocPad Configuration File
# http://docpad.org/docs/config

# Define the DocPad Configuration
docpadConfig = {
  regenerateDelay: 0
  ignoreHiddenFiles: true

  port: 9778
  checkVersion: true

  templateData:
    site:
      url: "http://univunix.com"
      title: "UnivUnix"
      description:
        "El portal unificado de Unix, sus derivados y el software libre.
        Ahora con temas mas allá del software."
      keywords: [
        "Unix",
        "GNU",
        "Linux",
        "Mac",
        "BSD",
        "software",
        "libre",
        "electrónica",
        "impresión",
        "3D"
      ]

    # Helper functions
    getDocumentTitle: ->
      if @document.title
        "#{@document.title} | #{@site.title}"
      else
        "#{@site.title}"

    getDocumentDescription: ->
      "#{@site.description}"

    mergeKeywords: ->
      @site.keywords.concat(@document.keywords or [])
      .join(", ")

    formatURL: (url) ->
      url
      .replace(/\s/g, "%20")
      .replace(/&/g, "&amp;")

    getFullURL: (relativeURL) ->
      @formatURL(@site.url + relativeURL)

  collections:
    articles: ->
      @getCollection('documents')
      .findAllLive({relativeOutDirPath: /articles[\/\\]\w+/}, [{date: -1}])
      .on "add", (model) ->
        model.setMetaDefaults({layout:"article"})

    pages: ->
      @getCollection('documents')
      .findAllLive({relativeOutDirPath: 'pages'}, [{date: -1}])
      .on "add", (model) ->
        #model.setMetaDefaults({layout:"page"})

    categories: ->
      @getCollection('documents')
      .findAllLive({relativeOutDirPath: 'categories'}, [{date: -1}])
      .on "add", (model) ->
        model.setMetaDefaults({layout:"articlelist"})

  #Plugins configuration

  #Event configuration

  #Environment configuration
  localeCode: 'es'
  env: 'development'

  environments:
    development:
      templateData:
        site:
          url: "http://localhost:9008"
      hostname: 'localhost'
      maxAge: false
      port: 9008
    production:
      hostname: 'univunix.com'
}

# Export the DocPad Configuration
module.exports = docpadConfig
