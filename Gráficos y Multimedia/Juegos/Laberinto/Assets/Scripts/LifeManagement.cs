using System.Collections;
using UnityEngine;
using UnityEngine.UI;


public class LifeManagement : MonoBehaviour
{
    public Text heartText;
    public static int vidas = 0;

    // Start is called before the first frame update
    void Start()
    {
        actualizarVidas();
    }

    public void actualizarVidas() {
        heartText.text = "Vidas: " + LifeManagement.vidas;
    }

    public void sumarVida() {
        if (LifeManagement.vidas < 3) 
        {
            LifeManagement.vidas++;
            actualizarVidas();
        }
    }

    public void restarVida() {
        LifeManagement.vidas--;
        actualizarVidas();
    }

}
