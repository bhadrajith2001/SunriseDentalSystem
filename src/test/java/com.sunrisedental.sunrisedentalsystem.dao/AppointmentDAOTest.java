package com.sunrisedental.sunrisedentalsystem.dao;

import com.sunrisedental.sunrisedentalsystem.models.Appointment;
import org.junit.jupiter.api.*;

import java.sql.Date;
import java.sql.Time;
import java.util.List;

import static org.junit.jupiter.api.Assertions.*;

@TestMethodOrder(MethodOrderer.OrderAnnotation.class)
public class AppointmentDAOTest {

    private static AppointmentDAO dao;
    private static Appointment testApp;
    private static int generatedId = -1;

    @BeforeAll
    public static void setUp() {
        dao = new AppointmentDAO();
        testApp = new Appointment();
        // Dummy data for automated testing
        testApp.setPatientName("JUnit Test Patient");
        testApp.setAddress("Automated Test Address");
        testApp.setContactNumber("0710000000");
        testApp.setDentistName("Dr. Perera");
        testApp.setTreatmentId(1);
        testApp.setAppointmentDate(Date.valueOf("2026-12-31"));
        testApp.setAppointmentTime(Time.valueOf("10:00:00"));
        testApp.setEmail("test@gmail.com"); // Email functionality included
    }

    @Test
    @Order(1)
    public void testAddAppointment() {
        boolean isAdded = dao.addAppointment(testApp);
        assertTrue(isAdded, "Step 1: Appointment should be added successfully to the database");
    }

    @Test
    @Order(2)
    public void testGetAllAppointmentsAndSetId() {
        List<Appointment> list = dao.getAllAppointments();
        assertNotNull(list, "Step 2: Appointment list should not be null");
        assertFalse(list.isEmpty(), "Appointment list should not be empty");

        // Find the auto-generated ID of our test patient to use in subsequent tests
        for (Appointment a : list) {
            if ("JUnit Test Patient".equals(a.getPatientName())) {
                generatedId = a.getAppointmentNo();
                break;
            }
        }
        assertTrue(generatedId > 0, "The generated ID for the test appointment should be found");
    }

    @Test
    @Order(3)
    public void testUpdateAppointment() {
        // Changing the patient name to test update logic
        testApp.setAppointmentNo(generatedId);
        testApp.setPatientName("JUnit Test Updated Name");

        boolean isUpdated = dao.updateAppointment(testApp);
        assertTrue(isUpdated, "Step 3: Appointment details should be updated successfully");
    }

    @Test
    @Order(4)
    public void testDeleteAppointment() {
        // Clean up the database by deleting the test record
        boolean isDeleted = dao.deleteAppointment(generatedId);
        assertTrue(isDeleted, "Step 4: Test Appointment should be deleted successfully");
    }
}