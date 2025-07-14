/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

/**
 *
 * @author NTKC
 */
public class CamPackage {
     private int id;
    private int camAmount;
    private int price;
    private String label;
    private int bonus;

    public CamPackage(int id, int camAmount, int price, String label) {
        this.id = id;
        this.camAmount = camAmount;
        this.price = price;
        this.label = label;
        this.bonus = 0;
    }

    public CamPackage(int id, int camAmount, int price, String label, int bonus) {
        this.id = id;
        this.camAmount = camAmount;
        this.price = price;
        this.label = label;
        this.bonus = bonus;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public int getCamAmount() {
        return camAmount;
    }

    public void setCamAmount(int camAmount) {
        this.camAmount = camAmount;
    }

    public int getPrice() {
        return price;
    }

    public void setPrice(int price) {
        this.price = price;
    }

    public String getLabel() {
        return label;
    }

    public void setLabel(String label) {
        this.label = label;
    }

    public int getBonus() {
        return bonus;
    }

    public void setBonus(int bonus) {
        this.bonus = bonus;
    }
    
}
