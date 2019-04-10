/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package Main;

import java.math.BigInteger;
import java.util.Random;

/**
 *
 * @author Benji
 */
public class Testing {

	/**
	 * @param args the command line arguments
	 */
	public static void main(String[] args) {
		BigInteger bi = new BigInteger(1024, new Random());
		// TODO code application logic here
		System.out.println(bi);
		System.out.println(bi.bitLength());
	}

}
