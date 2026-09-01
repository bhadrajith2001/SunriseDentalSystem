package com.sunrisedental.sunrisedentalsystem.models;

import java.sql.Date;
import java.sql.Time;

public class Appointment {
    private int appointmentNo;
    private String patientName;
    private String address;
    private String contactNumber;
    private String dentistName;
    private int treatmentId;
    private String treatmentName; // To easily display the name in UI
    private Date appointmentDate;
    private Time appointmentTime;
    private double totalCost;

    public Appointment() {}

    // Getters and Setters
    public int getAppointmentNo() { return appointmentNo; }
    public void setAppointmentNo(int appointmentNo) { this.appointmentNo = appointmentNo; }

    public String getPatientName() { return patientName; }
    public void setPatientName(String patientName) { this.patientName = patientName; }

    public String getAddress() { return address; }
    public void setAddress(String address) { this.address = address; }

    public String getContactNumber() { return contactNumber; }
    public void setContactNumber(String contactNumber) { this.contactNumber = contactNumber; }

    public String getDentistName() { return dentistName; }
    public void setDentistName(String dentistName) { this.dentistName = dentistName; }

    public int getTreatmentId() { return treatmentId; }
    public void setTreatmentId(int treatmentId) { this.treatmentId = treatmentId; }

    public String getTreatmentName() { return treatmentName; }
    public void setTreatmentName(String treatmentName) { this.treatmentName = treatmentName; }

    public Date getAppointmentDate() { return appointmentDate; }
    public void setAppointmentDate(Date appointmentDate) { this.appointmentDate = appointmentDate; }

    public Time getAppointmentTime() { return appointmentTime; }
    public void setAppointmentTime(Time appointmentTime) { this.appointmentTime = appointmentTime; }

    public double getTotalCost() { return totalCost; }
    public void setTotalCost(double totalCost) { this.totalCost = totalCost; }
}