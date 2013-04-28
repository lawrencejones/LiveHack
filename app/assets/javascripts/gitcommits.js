var script = document.createElement('script');
script.src = 'http://ajax.googleapis.com/ajax/libs/jquery/2.0.0/jquery.min.js';
script.type = 'text/javascript';
document.getElementsByTagName('head')[0].appendChild(script);

lastCommitTime = 0;

function onLoadGit() {
    setInterval (function() {
        var items = [];
        var repos = $.getJSON('http://livehack-facebook.herokuapp.com/git_data.json', function(data) {
                        $.each(data, function(i) {
                            if (lastCommitTime < data[0].time) {
                                lastCommitTime = data[0].time;
                            }
                            $.getJSON('https://api.github.com/repos/' + 
                                        data[i].user + '/' + 
                                        data[i].repo + '/' + 
                                        'commits', function(commits) {
                                            /*
                                            var postData = {
                                                "created_at": data[0].created_at,
                                                "id": data[0].id,
                                                "repo": data[0].repo,
                                                "time": commits[0].commit.author.date,
                                                "updated_at": new Date(),
                                                "user": data[0].user
                                             };
                                             
                                             // not working!!
                                             $.ajax({
                                               url: 'http://livehack-facebook.herokuapp.com/git_data/' + data[0].id + '.json',
                                               type: 'POST',
                                               contentType:'application/json',
                                               data: JSON.stringify(postData),
                                               dataType:'json'
                                             }); */
                                     
                                            $.each(commits, function(i) {
                                                time = Date.parse(commits[i].commit.author.date);
                                                items.push({name: commits[i].commit.author.name, comment: commits[i].commit.message, time: commits[i].commit.author.date});
                                            });
                                            
                                            items.sort(function(a, b) {return b.time - a.time});
                                            console.log("items sorted", items);
                                            $("#git_commits").html(items.filter(filterIndex));
                                        });
                        });   
                    }); 
                     
    }, 2000); 
   
   /* 
    setInterval(function() {
        var total_commits = 0;
        var repo_commits = new Array();
        var user_commits = new Array();
        var indexUser = 0;
        $.getJSON('http://livehack-facebook.herokuapp.com/git_data.json', function(data) {
            $.each(data, function(i) {
                var commits_per_repo = 0;
                var repos = $.getJSON('https://api.github.com/repos/' + 
                                data[i].user + '/' + 
                                data[i].repo + '/commits', function(commits) {
                                    //console.log('all commits ', commits);
                                    //console.log('commit length ', commits.length);
                                    total_commits += commits.length;
                                    commits_per_repo += commits.length;
                                    repo_commits[i] = commits_per_repo;
                                });
                //console.log("index ", repo_commits[i]);
                var contributors = $.getJSON('https://api.github.com/repos/' + 
                                        data[0].user + '/' + 
                                        data[0].repo + '/collaborators', function(users) {
                                            $.each(users, function(i) {
                                                //console.log("login", users[i].login, "contr ", users[i].contributions);
                                                user_commits[indexUser] = {users: users[i].login, contributions: users[i].contributions};
                                                indexUser++;
                                             });
                                             
                                        });
            });
            console.log("total", total_commits);   
        });
    }, 5000); */
}
   
/*    
function filterIndex(element, index, array) {
    return (index < 10);
}*/

