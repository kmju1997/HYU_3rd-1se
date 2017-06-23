
import java.io.*;
import java.util.*;

import gnu.io.*;

public class SimpleRead implements Runnable, SerialPortEventListener{
	static Enumeration portList;

	InputStream inputStream;
	SerialPort serialPort;
	Thread readThread;

	String readData = "";


	//SimpleRead 생성자c
	public SimpleRead(CommPortIdentifier portId){
		try{
			/*사용 매소드 :
			 * public CommPort open(java.lang.String appname, int timeout)
			 * 기능 : 
			 * 어플리케이션 이름과 타임아웃 시간 명시
			 */
			serialPort = (SerialPort) portId.open("SimpleReadApp", 2000);
		} catch(PortInUseException e){}

		try{
			//시리얼 포트에서 입력 스트림을 획득한다.
			inputStream = serialPort.getInputStream();
		}catch(IOException e){}

		//시리얼 포트의 이벤트 리스너로 자신을 등록한다.
		try{
			serialPort.addEventListener(this);
		}catch(TooManyListenersException e){}

		/* 시리얼 포트에 데이터가 도착하면 이벤트가 한 번 발생되는데
		 * 이 때, 자신이 리스너로 등록된 객체에게 이벤트를 전달 하도록 허용
		 */
		serialPort.notifyOnDataAvailable(true);

		//시리얼 통신 설정. Data Bit는 8, Stop Bit는 1, Parity Bit는 없음.
		try{
			serialPort.setSerialPortParams(9600, SerialPort.DATABITS_8, SerialPort.STOPBITS_1, SerialPort.PARITY_NONE);
		} catch(UnsupportedCommOperationException e){}

		//쓰레드 객체 생성
		readThread = new Thread(this);

		//쓰레드 동작
		readThread.start();
	}

	public void run() {
		try{
			Thread.sleep(20000);
		}catch(InterruptedException e){}
	}

	//시리얼 포트 이벤트가 발생하면 호출. 시리얼 포트 이벤트를 전달한다.
	public void serialEvent(SerialPortEvent event) {

		// 이벤트의 타입에 따라 switch 문으로 제어.
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
			//데이터가 도착하면
		case SerialPortEvent.DATA_AVAILABLE:
			byte[] readBuffer = new byte[1]; //byte 배열 객체 생성

			//입력 스트림이 사용 가능하면, 버퍼로 읽어 드린 후
			//String 객체로 변환하여 출력
			try{
				while(inputStream.available()>0){
					int numBytes = inputStream.read(readBuffer);
					String data = new String(readBuffer);

					if (data.contains("\0")){
						System.out.print("\n수신 > " + readData +"\n발신 > ");
						readData = "";

					}else readData += data;

				}

			} catch (IOException e){}
			break;
		}
	}
}