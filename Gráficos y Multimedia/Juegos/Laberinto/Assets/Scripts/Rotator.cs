using UnityEngine;
using System.Collections;

public class Rotator : MonoBehaviour {

	
	// Update is called once per frame
	void Update () {
        transform.Rotate(new Vector3(0f, 0f, 100f) * Time.deltaTime);
	}
}
