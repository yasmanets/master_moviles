using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
using UnityEngine.SceneManagement;


public class SceneManagement : MonoBehaviour
{
    public Text buttonText;
    public string title;

    // Start is called before the first frame update
    void Start()
    {
        buttonText.text = title;
    }

    // Update is called once per frame
    void Update()
    {
        
    }

    public void sceneManagement(string scene)
    {
        Time.timeScale = 1f;
        SceneManager.LoadScene(scene);
    }

    public void quitGame()
    {
        #if UNITY_EDITOR
		    UnityEditor.EditorApplication.isPlaying = false;
		#elif UNITY_WEBPLAYER
		    Application.OpenURL(webplayerQuitURL);
		#else
		    Application.Quit();
		#endif
    }
}
