# Test Fluent Timestamps

## Purpose

This is a test project to test issue :

https://github.com/vapor/fluent/issues/539


## Conclusion

The reported issue could not be reproduced by this project.

## Howto

- clone the repo in some new directory:<br/>
    ```

    $ cd <path to your projects directory>
    $ git clone https://github.com/mixio/test_fluent_timestamps.git
    $ cd test_fluent_timestamps
    ```
- update the project:<br/>
    ```
    $ vapor update -y
    ```
- run the tests:<br/><br/>
    - with Xcode:<br/><br/>
    Launch the project, go to the Test Navigatore, enable "AppTests" and run the tests.<br/><br/>
    - with vapor:<br/><br/>
    ```$ vapor test```<br/><br/>
    - with swift (more verbose):<br/><br/>
     ```$ swift test```<br/><br/>


Running the `testUpdateUserWithTheAPI()` test should produce the expected result.