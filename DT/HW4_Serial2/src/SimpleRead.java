
import java.io.*;
import java.util.*;

import gnu.io.*;

public class SimpleRead implements Runnable, SerialPortEventListener{
	static Enumeration portList;

	InputStream inputStream;
	SerialPort serialPort;
	Thread readThread;

	String readData = "";


	//SimpleRead ������c
	public SimpleRead(CommPortIdentifier portId){
		try{
			/*��� �żҵ� :
			 * public CommPort open(java.lang.String appname, int timeout)
			 * ��� : 
			 * ���ø����̼� �̸��� Ÿ�Ӿƿ� �ð� ���
			 */
			serialPort = (SerialPort) portId.open("SimpleReadApp", 2000);
		} catch(PortInUseException e){}

		try{
			//�ø��� ��Ʈ���� �Է� ��Ʈ���� ȹ���Ѵ�.
			inputStream = serialPort.getInputStream();
		}catch(IOException e){}

		//�ø��� ��Ʈ�� �̺�Ʈ �����ʷ� �ڽ��� ����Ѵ�.
		try{
			serialPort.addEventListener(this);
		}catch(TooManyListenersException e){}

		/* �ø��� ��Ʈ�� �����Ͱ� �����ϸ� �̺�Ʈ�� �� �� �߻��Ǵµ�
		 * �� ��, �ڽ��� �����ʷ� ��ϵ� ��ü���� �̺�Ʈ�� ���� �ϵ��� ���
		 */
		serialPort.notifyOnDataAvailable(true);

		//�ø��� ��� ����. Data Bit�� 8, Stop Bit�� 1, Parity Bit�� ����.
		try{
			serialPort.setSerialPortParams(9600, SerialPort.DATABITS_8, SerialPort.STOPBITS_1, SerialPort.PARITY_NONE);
		} catch(UnsupportedCommOperationException e){}

		//������ ��ü ����
		readThread = new Thread(this);

		//������ ����
		readThread.start();
	}

	public void run() {
		try{
			Thread.sleep(20000);
		}catch(InterruptedException e){}
	}

	//�ø��� ��Ʈ �̺�Ʈ�� �߻��ϸ� ȣ��. �ø��� ��Ʈ �̺�Ʈ�� �����Ѵ�.
	public void serialEvent(SerialPortEvent event) {

		// �̺�Ʈ�� Ÿ�Կ� ���� switch ������ ����.
		switch(event.getEventType()){
		case SerialPortEvent.BI:
		case SerialPortEvent.OE:
		case SerialPortEvent.FE:
		case SerialPortEvent.PE:
		case SerialPortEvent.CD:
		case SerialPortEvent.CTS:
		case SerialPortEvent.DSR:
		case SerialPortEvent.RI:
		case SerialPortEvent.OUTPUT_BUFFER_EMPTY:
			break;
			//�����Ͱ� �����ϸ�
		case SerialPortEvent.DATA_AVAILABLE:
			byte[] readBuffer = new byte[1]; //byte �迭 ��ü ����

			//�Է� ��Ʈ���� ��� �����ϸ�, ���۷� �о� �帰 ��
			//String ��ü�� ��ȯ�Ͽ� ���
			try{
				while(inputStream.available()>0){
					int numBytes = inputStream.read(readBuffer);
					String data = new String(readBuffer);

					if (data.contains("\0")){
						System.out.print("\n���� > " + readData +"\n�߽� > ");
						readData = "";

					}else readData += data;

				}

			} catch (IOException e){}
			break;
		}
	}
}