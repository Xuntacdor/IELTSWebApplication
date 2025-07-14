/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dao;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import model.CamPackage;
import util.DBConnection;

/**
 *
 * @author NTKC
 */
public class CamPackageDAO {

    public static CamPackage getPackageById(int id) {
        String sql = "SELECT * FROM CamPackages WHERE id = ?";
        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return new CamPackage(
                        rs.getInt("id"),
                        rs.getInt("camAmount"),
                        rs.getInt("price"),
                        rs.getString("label"),
                        rs.getInt("bonus")
                );
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public static List<CamPackage> getAllPackages() {
        List<CamPackage> list = new ArrayList<>();
        String sql = "SELECT * FROM CamPackages ORDER BY camAmount ASC";
        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                list.add(new CamPackage(
                        rs.getInt("id"),
                        rs.getInt("camAmount"),
                        rs.getInt("price"),
                        rs.getString("label"),
                        rs.getInt("bonus")
                ));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public static void main(String[] args) {
        System.out.println("🔎 Testing getAllPackages():");
        List<CamPackage> packages = CamPackageDAO.getAllPackages();
        for (CamPackage p : packages) {
            System.out.println("ID: " + p.getId()
                    + ", CAM: " + p.getCamAmount()
                    + ", Price: " + p.getPrice()
                    + ", Label: " + p.getLabel()
                    + ", Bonus: " + p.getBonus());
        }

        System.out.println("\n🔍 Testing getPackageById(1):");
        CamPackage pkg = CamPackageDAO.getPackageById(1);
        if (pkg != null) {
            System.out.println("ID: " + pkg.getId()
                    + ", CAM: " + pkg.getCamAmount()
                    + ", Price: " + pkg.getPrice()
                    + ", Label: " + pkg.getLabel()
                    + ", Bonus: " + pkg.getBonus());
        } else {
            System.out.println("❌ No package found with ID = 1");
        }
    }
}
