import javax.swing.*;

//ファイル選択画面、選択ファイルパス取得の処理 
String getFileName(){
  //処理タイミングの設定 
  SwingUtilities.invokeLater(new Runnable() { 
    public void run() {
      try {
        //ファイル選択画面表示 
        JFileChooser fc = new JFileChooser(); 
        int returnVal = fc.showOpenDialog(null);
        //「開く」ボタンが押された場合
        if (returnVal == JFileChooser.APPROVE_OPTION) {
          //選択ファイル取得 
          File file = fc.getSelectedFile();
          //選択ファイルのパス取得 
          getFile = file.getPath(); 
        } 
      } catch (Exception e) {
        e.printStackTrace(); 
      }
    }
  });
  //選択ファイルパス取得
  return getFile; 
}