using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.EventSystems; // ���������� ��� ������� � 'IPointerClickHandler' � 'PointerEventData

public class EventResponder : MonoBehaviour, IPointerClickHandler
{
    public void OnPointerClick(PointerEventData eventData)
    {
        Debug.Log("Clicked!");
    }
}
