using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;


public class CoinController : MonoBehaviour
{
    public AudioClip coinAudio;
    public CoinsController coins;

    // Start is called before the first frame update
    void Start()
    {

    }

    // Update is called once per frame
    void Update()
    {
        
    }

    void OnTriggerEnter(Collider collider)
    {
        if (collider.gameObject.CompareTag("player"))
        {
            coins.sumarCoin();
            AudioSource.PlayClipAtPoint(coinAudio, transform.position);
            Destroy(this.gameObject);
        }
    }
}
