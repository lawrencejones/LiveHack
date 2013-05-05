rake test_coffee;
clear; clear;
coffee ./test/coffeescript/HackathonsTest.coffee;
cat /Users/lawrencejones/Sites/Projects/LiveHack/tmp/pids/server.pid | xargs kill
