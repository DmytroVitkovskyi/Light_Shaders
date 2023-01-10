using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.EventSystems; // Необходимо для доступа к 'IPointerClickHandler' и 'PointerEventData

public class EventResponder : MonoBehaviour, IPointerClickHandler
{
    public void OnPointerClick(PointerEventData eventData)
    {
        Debug.Log("Clicked!");
    }
}
