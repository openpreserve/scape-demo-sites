Pagelyzer demo 
================

###Requirements:

The deployment and installation of demo for pagelyzer dependent on different other packages:

    - Selenium 2.29 // jar is provided on github
    - Firefox > 3.2
    - X server Xvfb
    - Available server ports: 8015 to 8025
    
    
###Installation:

**1-**  Xvfb is used  incase if the Graphical User Interface (GUI) is not available in your system but also not the open pop-up windows while demo. 

    $ Xvfb :1 -screen 0 1024x768x24 &

If you are already using Xvfb and display 1 is busy, you can choose another number but in that case, you should update check.php with this new display number. 

**2-**  The Selenium framework can be used in two different cases: the first one is to run it on the local machine and the second one is to run Selenium as a server. For this demo, we will use the second way. But the jPagelyzer.jar can be run on the local machine with -local option

    $ DISPLAY=:1 java -jar selenium-server-standalone-2.39.0.jar -port 8015 &

Be sure that selenium server is always running, unless the demo will not work.

**3-**  Keep the structure of the files on the web server: ex. jPagelyzer.jar and ext folder should on the same path

**4-**  For the following three files listed below you should change manually the paths inside. 
    - /ext/ex_images.xml
    - /ext/ex_structure.xml
    - /ext/ex_hybrid.xml

Example : /home/scape/public_html/pagelyzer/ to yourpath/pagelyzer/ 



    


