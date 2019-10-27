
using UnityEngine;

public class scrolling_helper : MonoBehaviour
{
    int count = 0;
    // Start is called before the first frame update
    void Start()
    {
       
      
        
    }

    // Update is called once per frame
    void Update()
    {
            this.GetComponent<Renderer>().material.SetFloat("timer", count);
            print(count);
            count++;
    }
}
