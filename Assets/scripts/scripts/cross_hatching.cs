using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class shader_helper : MonoBehaviour
{
    //public GameObject reference;
    public GameObject camera;
    public GameObject light;
    public float length = 5;
    public float height = 5;
    public float width = 5;
    // Start is called before the first frame update
    void Start()
    {
        Vector3 LD = light.GetComponent<Transform>().position;//light.transform.rotation.normalized;
        Quaternion CD = camera.transform.rotation.normalized;
        Vector4 CDD = new Vector4(CD.x, CD.y, CD.z, CD.w);
        Vector3 CP = camera.GetComponent<Transform>().position;

        Vector3 Origin = this.transform.position;
        this.GetComponent<Renderer>().material.SetVector("lightDir", new Vector4(LD.x,LD.y,LD.z,0));
        this.GetComponent<Renderer>().material.SetVector("camDir", CDD);
        this.GetComponent<Renderer>().material.SetVector("camPos", new Vector4(CP.x, CP.y, CP.z, 0) );
        this.GetComponent<Renderer>().material.SetVector("Origin", new Vector4(Origin.x, Origin.y, Origin.z, 0));
    }

    // Update is called once per frame
    void Update()
    {
        Vector3 LD = light.GetComponent<Transform>().position;//light.transform.rotation.normalized;
        Quaternion CD = camera.transform.rotation.normalized;
        Vector4 CDD = new Vector4(CD.x, CD.y, CD.z, CD.w);
        Vector3 CP = camera.GetComponent<Transform>().position;
        Vector3 Origin = this.transform.position;
        this.GetComponent<Renderer>().material.SetVector("lightDir", new Vector4(LD.x, LD.y, LD.z, 0));
        this.GetComponent<Renderer>().material.SetVector("camDir", CDD);
        this.GetComponent<Renderer>().material.SetVector("camPos", new Vector4(CP.x, CP.y, CP.z, 0) );
        this.GetComponent<Renderer>().material.SetVector("Origin", new Vector4(Origin.x, Origin.y, Origin.z, 0));
    }
}
