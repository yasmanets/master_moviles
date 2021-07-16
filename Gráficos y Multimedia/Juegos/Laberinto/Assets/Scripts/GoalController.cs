using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
using UnityEngine.SceneManagement;

public class GoalController : MonoBehaviour
{
    public AudioClip victoryAudio;
    public Text coinText;
    public Text heartText;
    public GameObject panel;
    public GameObject nextButton;
    public GameObject exitButton;
    public Text winText;

    private static string finalLevel = "level5";

    // Start is called before the first frame update
    void Start()
    {
        winText.enabled = false;
        nextButton.SetActive(false);
        exitButton.SetActive(false);
        panel.SetActive(false);
    }

    // Update is called once per frame
    void Update()
    {
        
    }

    void OnTriggerEnter(Collider collider)
    {
        if (collider.gameObject.CompareTag("player"))
        {
            AudioSource.PlayClipAtPoint(victoryAudio, transform.position);
            if (SceneManager.GetActiveScene().name != finalLevel)
            {
                Invoke("WinGame", 1f);
            }
            else
            {
                Invoke("FinishGame", 1f);
            }
        }
    }

    void WinGame()
    {
        coinText.enabled = false;
        heartText.enabled = false;
        winText.enabled = true;
        nextButton.SetActive(true);
        exitButton.SetActive(true);
        panel.SetActive(true);
        
        winText.text = "Nivel Superado!";
        Time.timeScale = 0f;
    }

    void FinishGame()
    {
        coinText.enabled = false;
        heartText.enabled = false;
        winText.enabled = true;
        exitButton.SetActive(true);
        panel.SetActive(true);
        
        winText.text = "Has acabdo el jeugo!!";
        Time.timeScale = 0f;
    }
}
