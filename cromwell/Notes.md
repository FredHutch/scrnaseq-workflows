# Cromwell Notes


## Installation

* from https://github.com/broadinstitute/cromwell 
* from https://cromwell.readthedocs.io/en/stable/tutorials/FiveMinuteIntro/

```
cd $HOME/Documents
mkdir cromwell
cd cromwell
```

* Manually download the latest Cromwell (cromwell.jar) file from https://github.com/broadinstitute/cromwell/releases/latest , and then copy it to $HOME/Documents/cromwell

```
mkdir -p $HOME/Documents/cromwell
```

...then put the cromwell .jar file in there

## Cromwell Tutorial ('Hello World')

Stored in the ./hello-world directory

```
cd $HOME/Documents/cromwell
java -jar cromwell-40.jar run helloworld.wdl
```

**Now run it as a server**

```
java -jar cromwell-40.jar server
```

* Follow the steps in https://cromwell.readthedocs.io/en/stable/tutorials/ServerMode/
* It works, but it's all API-driven, and verbose. Hard to debug or see what's going on.