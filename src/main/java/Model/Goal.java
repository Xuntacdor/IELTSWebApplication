/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package Model;

/**
 *
 * @author hmqua
 */
public class Goal {
    private float reading;
    private float listening;
    private float overall;

    public Goal(float reading, float listening, float overall) {
        this.reading = reading;
        this.listening = listening;
        this.overall = overall;
    }

    public float getReading() { return reading; }
    public float getListening() { return listening; }
    public float getOverall() { return overall; }

    @Override
    public String toString() {
        return "Goal{" + "reading=" + reading + ", listening=" + listening + ", overall=" + overall + '}';
    }
    
}
