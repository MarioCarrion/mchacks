using System;
using System.Collections.Generic;
using System.Text;
using System.Text.RegularExpressions;

public class Main1 {
	public static void Main (string[] args)
	{
		// - To match "something on March 1st" you will use "'something' o \M O\"
		//string example = @"'something' o \\";
		string example = @"'something' o \M O\";

		string tokensExpression = @"(\b\w\b|'\w+')+((?<=\s)(\b\w\b|'\w+'))*";
		string dateExpression = @"(?>\\)(\b\w\b|'\w+')+(?>.*?\\)";
		string fullExpression = string.Format ("{0}|{1}", tokensExpression, dateExpression);

		Console.WriteLine ("Text: \"{0}\"", example);
		// TODO:
		// - Use StringBuilder
		// - Remove duplicated code

		Regex regex = new Regex (fullExpression, RegexOptions.IgnoreCase);
		List<string> list0 = new List<string> ();
		foreach (Match match in regex.Matches (example)) {
			if (Regex.IsMatch (match.Value, dateExpression)) {
				Regex regex1 = new Regex (tokensExpression, RegexOptions.IgnoreCase);
				string date = "(?<date>";
				List<string> list1 = new List<string> ();
				foreach (Match match1 in regex1.Matches (match.Value)) {
					list1.Add (match1.Value.Trim (new char[] { '\'' }));
				}
				date += string.Join (@"\s+", list1.ToArray ()) + ")";
				list0.Add (date);
			} else
				list0.Add (string.Format (@"({0})", match.Value.Trim (new char[] { '\'' })));
		}
		Console.WriteLine ("Regex generated: {0}", String.Join (@"\s+", list0.ToArray ()));
	}
}

// If expressions throws exception then parsing, remove from list of expressions

// "Type"	| "Format specifier"	| "LITERAL Regular expression"		| "Can I get a date?				| Factor
// ----
// TomorrowToday| T			| "tomorrow|today"			| YES						| 0
// Month 	| M			| "January|Jan|February|Feb|..."	| YES						| 0
// Day		| D			| "Sunday|Sun|Monday|Mon|..."		| YES						| 0
// OrdinalNumber| O			| "00(st|nd|rd|th)"			| NO						| 0
// SeparatedDate| S			| "00/00/0000" "00-00-0000"		| YES						| 0
// DueBy	| U			| "due|due by|due before"		| NO						| 0
// Next		| n			| "next"				| Probably - needs some "Yes"			| 1
// This		| t			| "this"				| Probably - needs some "Yes"			| 0
// Week		| w			| "week|weeks"				| Probably - needs factor, ie, "in 2 weeks"	| 0
// Month	| m			| "month|months"			| Probably - needs factor, ie, "in 1 month"	| 0
// Year		| y			| "year|years"				| Probably - needs factor, ie, "next year"	| 0
// On		| o			| "on"					| N						| 0
// In		| i			| "in 000"				| N						| 000 defines factor


// If no \\ are found, the all text is <?date>, if so, then only the words delimited are. ie.
// - To match "something on March 1st" you will use "o \M O\"
// - To match "something in 1 month" you will use "i M"

// "tomorrow" -> T
// "today" -> T
// "due on monday" -> "U o \D\"
// "next month" -> "n M"
// "next monday" -> "n D"
// "due by next month" -> "U \n m\"
// "due by Feb" -> "U \M\"
// "in 2 months" -> "i m"
// "this week" -> "t w" # Evaluate singular? plural?
// "on 13th" -> "o O"
// "on March 13th" -> "o \M O\" in spanish -> "o O 'de' M"

// March 1st
