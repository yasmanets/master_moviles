using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class CoinsController : MonoBehaviour
{
    public Text coinText;
    public static int coins = 0;

    // Start is called before the first frame update
    void Start()
    {
        CoinsController.coins = 0;
        actualizarCoins();
    }

    public void actualizarCoins() {
        coinText.text = "Coins: " + CoinsController.coins;
    }

    public void sumarCoin() {
        CoinsController.coins++;
        actualizarCoins();
    }
}
