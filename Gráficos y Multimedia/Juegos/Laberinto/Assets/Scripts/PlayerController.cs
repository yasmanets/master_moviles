using UnityEngine;
using UnityEngine.UI;
using System.Collections;

public class PlayerController : MonoBehaviour {

	public float velocidad;
    public string level;
    public Text winText;
    public Text coinText;
    public Text heartText;
    public GameObject panel;
    public GameObject startButton;
    public GameObject restartButton;
    public GameObject exitButton;
    public GameObject continueButton;
	private Rigidbody rb;

    public LifeManagement lifeManagement;
    private GameObject board;
    private Vector3 boardPosition;

	void Start() 
	{
		rb = GetComponent<Rigidbody>();
        board = GameObject.Find(level);
        
        hideCanvas();
	}

    // Update is called once per frame
    void FixedUpdate()
    {
        float posH = Input.GetAxis("Horizontal");
        float posV = Input.GetAxis("Vertical");

        Vector3 movimiento = new Vector3(posH, 0.0f, posV);

        rb.AddForce(movimiento * velocidad);
    }

    private void OnTriggerExit(Collider other)
    {
		if (other.gameObject.CompareTag("tablero"))
		{
            if (LifeManagement.vidas > 0)
            {
                boardPosition = other.gameObject.transform.position;
                displayCanvas("Te has caído!");
            }
            lifeManagement.restarVida();
		}
	}

    public void continueGame()
    {
        hideCanvas();
        transform.position = new Vector3(boardPosition.x + 0.1f, 0.1f, boardPosition.z);
        board.transform.eulerAngles = new Vector3(-90, 0, 0);
    }

    private void hideCanvas()
    {
        Time.timeScale = 1f;
        winText.enabled = false;
        restartButton.SetActive(false);
        startButton.SetActive(false);
        exitButton.SetActive(false);
        continueButton.SetActive(false);
        panel.SetActive(false);
    }

    private void displayCanvas(string text)
    {
        Time.timeScale = 0f;
        winText.enabled = true;
        restartButton.SetActive(true);
        exitButton.SetActive(true);
        continueButton.SetActive(true);
        panel.SetActive(true);
        winText.text = text;
    }

}