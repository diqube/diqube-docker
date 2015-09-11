#diqube - Docker "build and run"#

This directory provides the possibility to create a Dockerfile with its environment which will, when an image is created, build a specific version of diqube from source and then start it. This will then provide a single-node server setup with a running diqube UI.

##How to get started##

1. Call the [prepare.sh](prepare.sh) script with the commit ID in the diqube repository of which you would like to have a Docker image.
  * Please note that any git commit reference will work (e.g. `master` will work, too), but be aware that the resulting Dockerfile will result in non-deterministic images for non-commit-id values: Each time you build the image it might (and probably will) result in a different version of diqube being built and run!
2. Go to the directory where `prepare.sh` put the output files.
3. Build the Docker image (might take a while):
  ```
  docker build -t diqube/diqube-server . 
  ```
4. Start the container:
  ```
  docker run -d -p 8080:8080 --name diqube diqube/diqube-server 
  ```

The UI will then be available under the URL `http://localhost:8080/diqube-ui`.

##Deploy some data##

An empty diqube server is obviously not of any use. So you need to deploy some data. You might want to use the sample data provided in the [diqube-server/data](https://github.com/diqube/diqube/tree/master/diqube-server/data) directory, you might want to build bigger data sets by inspecting the [diqube-data-examples](https://github.com/diqube/diqube-data-examples) repository or you could prepare your custom data, too, of course. 

For more information, you might want to look at the "Loading data" chapter in the [Operating a cluster guide](https://github.com/diqube/diqube/blob/master/docs/OperatingCluster.md) of diqube.

###Prepare a SSH container and bind volumes###

After you prepared your data and have both the data file and the .control file at hand, you need to deploy the data. The Docker image will provide "volumes" which can be mapped in other containers, too. As an example, let's use the [centos-ssh container of jdeathe](https://github.com/jdeathe/centos-ssh):

```
docker run -d --name ssh -p 2022:22 --volumes-from diqube jdeathe/centos-ssh:latest
```

Then, to connect to the SSH server, use the following (for details see the documentation of the centos-ssh container itself):

```
curl -LsSO https://raw.githubusercontent.com/mitchellh/vagrant/master/keys/vagrant

chmod 0600 vagrant

ssh -i vagrant -p 2022 app-admin@localhost -o StrictHostKeyChecking=no
```

To execute any `sudo` commands you need the corresponding passwords which can be found by executing `docker logs ssh`.

###Copy data to volumes###

The directory the diqube server is watching for new data is in the volume at `/home/diqube/diqube-server-work/data`. Use SCP to first copy your data file to the volume and after that copy the .control file into that data directory. diqube server will load your data and you can start querying it using the UI.
