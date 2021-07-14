using System.Collections;
using UnityEngine;
using UnityEngine.UI;


public class LifeManagement : MonoBehaviour
{
    public Text heartText;
    public static int vidas = 0;
    public AudioClip loseAudio;
    public Text coinText;
    public GameObject panel;
    public GameObject exitButton;
    public Text winText;

    // Start is called before the first frame update
    void Start()
    {
        LifeManagement.vidas = 0;
        actualizarVidas();
        winText.enabled = false;
        exitButton.SetActive(false);
        panel.SetActive(false);
    }

    public void actualizarVidas() {
        heartText.text = "Vidas: " + LifeManagement.vidas;
    }

    public void sumarVida()
    {
        if (LifeManagement.vidas < 3) 
        {
            LifeManagement.vidas++;
            actualizarVidas();
        }
    }

    public void restarVida()
    {
        if (LifeManagement.vidas == 0) 
        {
            AudioSource.PlayClipAtPoint(loseAudio, transform.position);
            coinText.enabled = false;
            heartText.enabled = false;
            winText.enabled = true;
            exitButton.SetActive(true);
            panel.SetActive(true);
            
            winText.text = "No tienes vidas...";
            Time.timeScale = 0f;
        }
        LifeManagement.vidas--;
        actualizarVidas();
    }

}
