private void saveImageToInternalStorage(Bitmap bitmap) {
    // Get the context wrapper
    ContextWrapper cw = new ContextWrapper(getApplicationContext());

    // Create a directory for your app's private pictures
    File directory = cw.getDir("imageDir", Context.MODE_PRIVATE);

    // Create the image file
    File mypath = new File(directory, "myImage.jpg");

    FileOutputStream fos = null;
    try {
        fos = new FileOutputStream(mypath);
        // Use the compress method on the Bitmap object to write image to the OutputStream
        bitmap.compress(Bitmap.CompressFormat.PNG, 100, fos);
    } catch (Exception e) {
        e.printStackTrace();
    } finally {
        try {
            fos.close();
        } catch (IOException e) {
            e.printStackTrace();
        }
    }
}
