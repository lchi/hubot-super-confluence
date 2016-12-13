# Description
#   A hubot script for searching and browsing Confluence. Very super.
#
# Configuration:
# HUBOT_CONFLUENCE_USERNAME - Confluence username.
# HUBOT_CONFLUENCE_PASSWORD - Confluence password.
# HUBOT_CONFLUENCE_HOST - Hostname of the Confluence instance.
# HUBOT_CONFLUENCE_CONTEXT (optional) - Often '/wiki', defaults to ''
# HUBOT_SUPER_CONFLUENCE_AUTORESPONSE_REGEX (optional) -
#   Sets up a `hear` callback on the first capture group of the regex.
#   For example, if set to "how do i (.*)" and someone asks 'how can i
#   deploy' then the Confluence will be queried with `deploy`.
#
# Commands:
#   hubot wiki <query> - Perform a full text search with <query>
#
# Author:
#   Lucas Chi

confluence = require('atlassian-confluence')

confluence.username = process.env.HUBOT_CONFLUENCE_USERNAME
confluence.password = process.env.HUBOT_CONFLUENCE_PASSWORD
confluence.host = process.env.HUBOT_CONFLUENCE_HOST
confluence.context = process.env.HUBOT_CONFLUENCE_CONTEXT or ''

CONFLUENCE_BASE_URL = "https://#{confluence.host}#{confluence.context}"

module.exports = (robot) ->
  robot.respond /wiki\s+(.*)$/i, (response) ->
    textSearch response

  autorespond_regex = process.env.HUBOT_SUPER_CONFLUENCE_AUTORESPONSE_REGEX
  if autorespond_regex
    robot.hear new RegExp(autorespond_regex, 'i'), (response) ->
      autoRespond response

textSearch = (response) ->

  query = encodeURIComponent(response.match[1])
  opts =
    limit: 5

  confluence.advancedSearch "type=page and text~\"#{query}\"", opts, (err, res) ->
    if err
      response.send err
    else
      numResults = res.results.length
      if numResults is 0
        response.send "No matches found for '#{query}'"
      else
        response.send "#{numResults} matches found (limit: #{opts.limit})"
        sendMatchesFound res.results, opts.limit, (s) -> response.send s

autoRespond = (response) ->

  query = encodeURIComponent(response.match[1])
  opts =
    limit: 5

  confluence.advancedSearch "type=page and text~\"#{query}\"", opts, (err, res) ->
    if err
      response.send err
    else
      numResults = res.results.length
      if numResults > 0
        response.reply "#{numResults} matches found (limit: #{opts.limit})"
        sendMatchesFound res.results, opts.limit, (s) -> response.reply s

sendMatchesFound = (results, limit, response_function) ->
  pages = []

  for page in results
    pageLink = "#{CONFLUENCE_BASE_URL}#{page._links.webui}"
    pages.push "#{page.title} - #{pageLink}"

  response_function pages.join '\n'
