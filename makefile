mergeintomaster:
	git checkout master
	git pull origin master
	git pull origin model
	git pull origin view
	git pull origin controller
	git merge model
	git merge view
	git merge controller
	git push origin master

model:
	git checkout master
	git pull origin master
	git checkout model
	git merge master
	git push origin model

view:
	git checkout master
	git pull origin master
	git checkout view
	git merge master
	git push origin view

controller:
	git checkout master
	git pull origin master
	git checkout controller
	git merge master
	git push origin controller