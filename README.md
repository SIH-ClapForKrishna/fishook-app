# SIH_FisHookApp
Team ClapForKrishna's app made for SIH'22 finals.


Guidelines:
1) **(BEFORE RUNNING)**
    Open either:
    "X:\src\flutter\flutter\.pub-cache\hosted\pub.dartlang.org\tflite-1.1.2\android" or
    "X:\Users\Username\AppData\Local\Pub\Cache\hosted\pub.dartlang.org\tflite-1.1.2\android".
   Open **build.gradle** and change dependencies {} in android{} as follows:
    *dependencies {
        implementation 'org.tensorflow:tensorflow-lite:+'
        implementation 'org.tensorflow:tensorflow-lite-gpu:+'
    }*.
