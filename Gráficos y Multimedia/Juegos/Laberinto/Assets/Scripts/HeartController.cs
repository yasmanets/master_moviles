using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class HeartController : MonoBehaviour
{
    public AudioClip heartAudio;
    public LifeManagement life;

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
            life.sumarVida();
            AudioSource.PlayClipAtPoint(heartAudio, transform.position);
            Destroy(this.gameObject);
        }
    }
}
