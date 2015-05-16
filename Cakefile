

{exec} = require 'child_process'

task 'build', 'Build project from src/*.coffee to lib/*.js', ->
    exec 'coffee --compile --output build/ lib/', (err, stdout, stderr) ->
        throw err if err
        console.log stdout + stderr

option '-m', '--message [MESSAGE]', 'set commit message for `git`'
task 'git', 'commit -am and push', (options) ->
    console.log 'commit...'

    exec "git commit -am '#{options.message || 'no msg'}'", (err, stdout, stderr) ->
        throw err if err
        console.log stdout + stderr

        console.log 'push...'
        exec "git push", (err, stdout, stderr) ->
            throw err if err
            console.log stdout + stderr
            console.log "done"
