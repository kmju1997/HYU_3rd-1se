
import java.io.*;
import java.util.*;

import gnu.io.*;

public class SimpleChat{
	static CommPortIdentifier portId;
	static Enumeration portList;
	static String messageString = "Hello, World!\n";
	static OutputStream outputStream;


	private static Scanner output; //표준입력으로 부터, 발신할  데이터를 받아옴

	public static void main(String[] args){
		// 시스템에 있는 가능한 드라이버의 목록을 받아온다.
		portList = CommPortIdentifier.getPortIdentifiers();

		// enumeration type인 portList의 모든 객체에 대하여
		while(portList.hasMoreElements()){
			//enumeration에서 객체를 하나 가져온다.
			portId = (CommPortIdentifier) portList.nextElement();
			// 가져온 객체의 port type 이 serial port 이면
			if(portId.getPortType() == CommPortIdentifier.PORT_SERIAL){
				if(portId.getName().equals("COM8")){
					//객체 생성
					SimpleRead reader = new SimpleRead(portId);

					try{

						outputStream = reader.serialPort.getOutputStream();
					}catch(IOException e){}

					while(true){
						System.out.print("발신 > ");
						output = new Scanner(System.in);
						messageString = output.nextLine();
						messageString += "\0";

						try{
							outputStream.write(messageString.getBytes());
						}catch(IOException e){}
					}
				}
			}
		}
	}
}