
import Foundation

class Program
{
    var userDictionary = [String: String]()
  // as soon as an instance of a class is called,
  // the init() will be called
      init()
      {
         var reply = ""
         var keepRunning = true
         var passwordKey: String?
         var password: String?
          while keepRunning
          {
            // call main menu
            mainMenu()
            reply = Ask.AskQuestion(questionText: "Do you want to keep running the app(yes/no)?",acceptableReplies: ["no", "yes"])
            if reply == "no"
            {
                keepRunning = false
            }
          }
          
      }
    // NEW
    func mainMenu()
    {
        // menu option: View all password names, View a single password, Delete a password
        var menuOption: String?
        var passwordKey = ""
        var password = ""
        userDictionary = readJSON2()
        //print("Here")
        //viewKeys(uDictionary: &userDictionary)
        print("A. View all password names")
        print("B. View a single password")
        print("C. Delete a password")
        print("D. Add key,password")
        menuOption = readLine()
        String(menuOption!)
        switch menuOption
        {
           case "A":
            viewKeys(uDictionary: &userDictionary)
           case "B":
            viewSingle()
           case "C":
            deleteSingle()
           case "D":
            addSingle()
           default:
            break

        }
    }

    // View all the password keys
    func viewKeys (uDictionary: inout Dictionary<String,String>)
    {
        for (key,value) in uDictionary
        {
            print("key: \(key)")
        }
    }
    // Diagnostic function that prints both the key and the value in the dictionary
    func viewAllDiag (uDictionary: inout Dictionary<String,String>)
    {
        for entry in uDictionary
        {
            print("entry: \(entry)")
        }
    }
    
    // deleteSingle(): Delete the key given by the user
    func deleteSingle()
    {
        var keyExists:Bool
        var isKeyHere:Bool
        var userKey: String?
        print("Enter the password key: ")
        userKey = readLine()
        String(userKey!)
        // check if key exists in dictionary
        if let checkKey = userDictionary[userKey!]
        {
            print("Yes, the key exists in the dictionary" )
            // ask for the user’s passphrase to de-scramble the password and display it
            isKeyHere = true
            // if it does exists then delete it
            if(isKeyHere)
            {
                print("Removing Key: \(userKey) ")
                userDictionary.removeValue(forKey: userKey!)
                // Write to JSON
                writeToJSON(userDiciontary: &userDictionary)
            }
        }
        else
        {
            print("Does not exists")
            print("Returning to Main Menu")
            mainMenu()
        }
    }

    // addSingle(): Add key and value to dictionary
    func addSingle ()
    {
        var userPasswordKey:String?
        var userPassword:String?
        var userPassphrase:String?
        var appendPasswords:String
        var encryptedPass:String
        print("Enter key for password")
        userPasswordKey = readLine()
        print("Enter a password")
        userPassword = readLine()
        print("Enter a passphrase")
        userPassphrase = readLine()
        // append passphrase to password
        appendPasswords = String(userPassword!) + String(userPassphrase!)
        encryptedPass = encrypt(encryptString: appendPasswords)
        // add to Dictionary
        userDictionary[userPasswordKey!] = encryptedPass
        // Write to JSON
        writeToJSON(userDiciontary: &userDictionary)
        
    }

    // encrypt(): encrypts the password
    func encrypt (encryptString: String)->String
    {
        var str = encryptString
        var strShift = ""
        var shift = str.count
        // reverse the string
        str = reverseInput(stringToReverse: str)
        // Diag:
        //print("Reversed String: \(str)")
        // check how much to shift and encrypt by calling translate
        strShift = translateString(strForward: str, shiftForwardCount: shift)
        return strShift
    }
    // reverseInput(): reverses the string
    func reverseInput(stringToReverse input: String) -> String
    {
        // reverse() will return a character array [w, o, r, r, u, B]
        // So, we cast it as a String
        // output: worruB
        return String(input.reversed())
    }
    // translate(): executes caesar cipher
    func translate(l: Character, trans:Int) -> Character
    {
        if let ascii = l.asciiValue
        {
            var outputInt = ascii
            // lowercase
            if ascii >= 97 && ascii <= 122
            {
                                            
                // ex: a = 97            b = 98 --> 97
                //     97 - 97 = 0   // 98 - 97 = 1
                //     0 + 27 = 27   //
                //     27 % 26 = 1   //
                //     1 + 97 = 98
                //     98 = b
                outputInt = ((ascii - 97 + UInt8(trans))%26) + 97
            }
            else if( ascii >= 65 && ascii <= 90)
            {
                outputInt = ((ascii - 65 + UInt8(trans))%26) + 65
            }
            return Character(UnicodeScalar(outputInt))
        }
        return Character("")
    }



    // View Single
    // ask for key
       // Exists: ask for passphrase
       // No: direct back to main menu
    // decrypt
       // params: key: String passphrase: String
       // returns the decrypted or plain text of password: String
       // 1. find the key in the dictionary
       // 2. access the password
       // 3. reverse caesar cipher
       // 4. reverse the string
       
       // 5. Check if passphrase matches the end of the string
             // take the string count # (9) helloRico
             // take the passphrase count # (4) Rico
             // create a var = string.count#(9) - passphrast.count#(4) = 5
             // for loop starts at 5 to string.max# (9) --> create a rangle from 5 to 9
                // str += string[i]
             // if str == passphrase
                 // for loop string ..< 5
                   // strPass += string[i]
                 // return strPass;
             // else
                 // return ("Error: passphrase does not match)
       // return string
    
    
    //viewSingle(): if key exists in dictionary, ask for passphrase and de-scramble the password
    func viewSingle()
    {
        var userKey: String?
        var userPassphrase: String?
        print("Enter the password key: ")
        userKey = readLine()
        String(userKey!)
        // check if key exists in dictionary
        if let checkKey = userDictionary[userKey!]
        {
            print("Yes, key exists in the dictionary" )
            // ask for the user’s passphrase to de-scramble the password and display it
            print("Enter the passphrase: ")
            userPassphrase = readLine()
            decrypt(key: String(userKey!), passphrase: String(userPassphrase!))
            
        }
        else
        {
            print("Returning to Main Menu")
        }

    }

    // decrypt(): decrypts string
    func decrypt(key:String, passphrase:String)->String
    {
           
        var decryptedString:String
        var strShift:String = ""
        // access the password
        let encryptedPass:String? = userDictionary[key]
        var shift = String(encryptedPass!).count
        // NEW
        strShift = translateBackString(strBack: String(encryptedPass!), shiftBackCount: shift)
        // reverse the string
         decryptedString = reverseInput(stringToReverse: strShift)
        // Diag:
         //print("decrypted: \(decryptedString)")
        // Check if the passphrase matches the end of the string
         var decryptedCount:Int = decryptedString.count
         var passphraseCount:Int = passphrase.count
         var start:Int = decryptedCount - passphraseCount
         var isolatePhrase: String = ""
         var givePassword:String = ""
        // Diag:
        // print("start \(start)")
        // get passpharse from decrypted string
         let startPoint = decryptedString.index(decryptedString.startIndex, offsetBy: start)
         let endPoint = decryptedString.endIndex
         let range = startPoint..<endPoint
         isolatePhrase += decryptedString[range]
        // Check if the isolated phrase from the password
        if(isolatePhrase == passphrase)
        {
            // return the password to the user
            // from index 0 to but not including start
            let startPass = decryptedString.startIndex
            let endPass = decryptedString.index(decryptedString.startIndex, offsetBy: start)
            let rangePass = startPass..<endPass
            givePassword += decryptedString[rangePass]
            print("password: \(givePassword)")
            return(givePassword)
        }
        else
        {
            return ("Error: passphrase does not match")
        }
       
    }

    // translateBack(): reverse Casar Cipher
    func translateBack (l: Character, trans:Int) -> Character
    {
        /*
         Reverse the Caesar Cipher on all alpha characters
         Reverse the resultant string
         Check if the passphrase matches the end of the resultant string
         If it does, remove it from the string and return the password to the user
         If it doesn’t, return an error message
        */
         // Reverse the Caesar Cipher
        if let ascii = l.asciiValue
        {
            var outputInt = ascii
            // lowercase
            if ascii >= 97 && ascii <= 122
            {
                                            
                // ex: a = 97            b = 98 --> 97
                //     97 - 97 = 0   // 98 - 97 = 1
                //     0 + 27 = 27   //
                //     27 % 26 = 1   //
                //     1 + 97 = 98
                //     98 = b
                let asciiNum = ascii - UInt8(trans)
                if (asciiNum < 97)
                {
                    outputInt = outputInt + 26
                }
                else if(asciiNum > 122)
                {
                    outputInt = outputInt - 26
                }
                outputInt = (((outputInt - 97) - UInt8(trans)) % 26) + 97
                // Diag
                //print("IN HERE1")
            }
            else if( ascii >= 65 && ascii <= 90)
            {
                let asciiNum = ascii - UInt8(trans)
                if(asciiNum < 65)
                {
                    outputInt = outputInt + 26
                }
                else if(asciiNum > 90)
                {
                    outputInt = outputInt - 26
                }
                outputInt = (((outputInt - 65) - UInt8(trans))%26) + 65
               // Diag
               //  print("IN HERE2")
            }
            return Character(UnicodeScalar(outputInt))
        }
        return Character("")
    }

    // translateString(): function returns string after caesar cipher
    func translateString(strForward:String, shiftForwardCount:Int)->String
    {
        var strShift:String = ""
        for letter in strForward{
            // we what to know what letter to translate and how much you want to shift
            strShift += String(translate(l: letter, trans: shiftForwardCount))
        }
        return strShift
    }
    //translateBackString(): function returns string after reverse caesat cipher
    func translateBackString(strBack:String, shiftBackCount:Int)->String
    {
        var strShiftBack:String = ""
        for letter in strBack{
            // we what to know what letter to translate and how much you want to shift
            strShiftBack += String(translateBack(l: letter, trans: shiftBackCount))
        }
        return strShiftBack
    }


}

// we create a instance of the program class
let p = Program()

class Ask
{
    static func AskQuestion(questionText output: String, acceptableReplies inputArr: [String], caseSensitive: Bool = false) -> String
    {
        // Ask our question
        print(output)
        
        // Handle response
        guard let response = readLine() else {
            print("Invalid input")
            return AskQuestion(questionText: output, acceptableReplies: inputArr)
        }
        // they typed in the valid response
        // verify if the response if acceptable
        // OR if we don't care what the response is
        if(inputArr.contains(response) || inputArr.isEmpty)
        {
            return response
        }
        else
        {
           print("Invalid input ")
            return AskQuestion(questionText: output, acceptableReplies: inputArr)
        }
    }
}

// JSON Files

func writeToJSON(userDiciontary: inout Dictionary<String, String>){
    //var dictionary: [String:String] = ["Twitter": "password01", "Facebook": "password02", "Instagram": "password03"]
    var dictionary: [String:String] = userDiciontary
    do{
        let fileURL = try  FileManager.default
            // application Directory: supporting folder, userDomainMask (curr login), combine file name with endpoint file name
            // if the filwpath does not exists, create it
            .url(for: .applicationSupportDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            // append a componennt
            // add to end of path
            .appendingPathComponent("userPasswords.json")
        try JSONSerialization.data(withJSONObject: dictionary).write(to: fileURL)
    } catch{
        print(error)
    }
}

func readJSON2()->Dictionary<String,String>
{
    var dictionary = [String:String]()
    do{
        let fileURL = try  FileManager.default
            // application Directory: supporting folder, userDomainMask (curr login), combine file name with endpoint file name
            // if the filwpath does not exists, create it
            .url(for: .applicationSupportDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            // append a componennt
            // add to end of path
            .appendingPathComponent("userPasswords.json")
          //print(fileURL)
          let data = try Data (contentsOf: fileURL)
        dictionary = try JSONSerialization.jsonObject(with: data) as! [String : String]
        
    } catch{
        print(error)
    }
    return dictionary
}


