
import java.io.*;
import java.util.*;

import gnu.io.*;

public class SimpleChat{
	static CommPortIdentifier portId;
	static Enumeration portList;
	static String messageString = "Hello, World!\n";
	static OutputStream outputStream;


	private static Scanner output; //ǥ���Է����� ����, �߽���  �����͸� �޾ƿ�

	public static void main(String[] args){
		// �ý��ۿ� �ִ� ������ ����̹��� ����� �޾ƿ´�.
		portList = CommPortIdentifier.getPortIdentifiers();

		// enumeration type�� portList�� ��� ��ü�� ���Ͽ�
		while(portList.hasMoreElements()){
			//enumeration���� ��ü�� �ϳ� �����´�.
			portId = (CommPortIdentifier) portList.nextElement();
			// ������ ��ü�� port type �� serial port �̸�
			if(portId.getPortType() == CommPortIdentifier.PORT_SERIAL){
				if(portId.getName().equals("COM8")){
					//��ü ����
					SimpleRead reader = new SimpleRead(portId);

					try{

						outputStream = reader.serialPort.getOutputStream();
					}catch(IOException e){}

					while(true){
						System.out.print("�߽� > ");
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