using System;
using System.Numerics;

namespace crypto
{
	static class Program
	{
		static void Main(string[] args)
		{
			uint b;
			if(args.Length < 1 || !uint.TryParse (args [0], out b))
				Console.WriteLine ("Need to pass in a positive integer followed by as many textual messages as you like");
			else {
				Console.WriteLine ($"Base: {args[0]}");
				for(int i = 1; i < args.Length; i++)
					Console.WriteLine ($"{args[i]} -> {encrypt(args[i], b)}");
			}
		}

		static BigInteger encrypt(string str, uint b)
		{
			BigInteger msg = 1;
			foreach (char c in str) {
				msg *= 100;
				if(c >= 'a' && c <= 'z')
					msg += c - 'a';
				else if(c >= 'A' && c <= 'Z')
					msg += c - 'A';
			}
			msg *= 10;
			msg += 1;
			return msg.flip (b);
		}

		static BigInteger flip(this BigInteger number, BigInteger b)
		{
			BigInteger output = 0;
			while(number != 0) {
				output *= b;
				output += number % b;
				number /= b;
			}
			return output;
		}
	}
}