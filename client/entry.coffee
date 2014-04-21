AccountsEntry =
  settings:
    wrapLinks: true
    homeRoute: '/home'
    dashboardRoute: '/dashboard'
    passwordSignupFields: 'EMAIL_ONLY'
    emailToLower: true
    usernameToLower: false
    entrySignUp: '/sign-up',
    templates:
      entrySignIn: 'entrySignIn',
      entrySignUp: 'entrySignUp',
      entryForgotPassword: 'entryForgotPassword',
      entrySignOut: 'entrySignOut'

  isStringEmail: (email) ->
    emailPattern = /^([\w.-]+)@([\w.-]+)\.([a-zA-Z.]{2,6})$/i
    if email.match emailPattern then true else false

  config: (appConfig) ->
    @settings = _.extend(@settings, appConfig)

    T9n.defaultLanguage = "en"
    if appConfig.language
      T9n.language = appConfig.language

    templates = appConfig.templates
    if templates?
      for oldName, newName of templates
        route = Router.routes[oldName]
        if route?
          route.options.template = newName
          Template[newName].helpers = Template[oldName].helpers
          Template[newName].events = Template[oldName].events

  signInRequired: (router, extraCondition) ->
    extraCondition ?= true
    unless Meteor.loggingIn()
      unless Meteor.user() and extraCondition
        Session.set('fromWhere', router.path)
        Router.go('/sign-in')
        Session.set('entryError', i18n('error.signInRequired'))
        router.pause()

@AccountsEntry = AccountsEntry


class @T9NHelper

  @translate: (code) ->
    T9n.get code, "error.accounts"

  @accountsError: (err) ->
    Session.set 'entryError', @translate err.reason
