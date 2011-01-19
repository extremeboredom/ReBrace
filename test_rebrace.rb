require 'rebrace.rb'
require 'test/unit'

class TestRebracer < Test::Unit::TestCase
  def rebraceToString(input)
    output = ""
    Rebracer.new(input).rebrace { |line| output += line }
    return output
  end
  
  def test_simple
    input = <<-END_OF_CODE
      if (x == 1) {
        ++x;
      }
    END_OF_CODE
    expected = <<-END_OF_CODE
      if (x == 1) 
      {
        ++x;
      }
    END_OF_CODE
    assert_equal(expected, rebraceToString(input))
  end
  
  def test_simple_extra_space
    input = <<-END_OF_CODE
      if (x == 1) {      
        ++x;
      }
    END_OF_CODE
    expected = <<-END_OF_CODE
      if (x == 1) 
      {
        ++x;
      }
    END_OF_CODE
    assert_equal(expected, rebraceToString(input))
  end
  
  def test_nochange
    input = <<-END_OF_CODE
      if (x == 1)
      {
        ++x;
      }
    END_OF_CODE
    expected = <<-END_OF_CODE
      if (x == 1)
      {
        ++x;
      }
    END_OF_CODE
    assert_equal(expected, rebraceToString(input))
  end
  
  def test_complex
    input = <<-END_OF_CODE
      // Customize the appearance of table view cells.
      - (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

          static NSString *CellIdentifier = @"Cell";

          UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
          if (cell == nil) {
              cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
          }

          // Configure the cell...

          return cell;
      }
    END_OF_CODE
    expected = <<-END_OF_CODE
      // Customize the appearance of table view cells.
      - (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath 
      {

          static NSString *CellIdentifier = @"Cell";

          UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
          if (cell == nil) 
          {
              cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
          }

          // Configure the cell...

          return cell;
      }
    END_OF_CODE
    assert_equal(expected, rebraceToString(input))
  end
  
  def test_complex_exta_space
    input = <<-END_OF_CODE
      // Customize the appearance of table view cells.
      - (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {    

          static NSString *CellIdentifier = @"Cell";

          UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
          if (cell == nil) {  
              cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
          }

          // Configure the cell...

          return cell;
      }
    END_OF_CODE
    expected = <<-END_OF_CODE
      // Customize the appearance of table view cells.
      - (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath 
      {

          static NSString *CellIdentifier = @"Cell";

          UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
          if (cell == nil) 
          {
              cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
          }

          // Configure the cell...

          return cell;
      }
    END_OF_CODE
    assert_equal(expected, rebraceToString(input))
  end
  
  def test_comment_ending
    input = <<-END_OF_CODE
      if (x == 1) { // Comment
        ++x;
      }
    END_OF_CODE
    expected = <<-END_OF_CODE
      if (x == 1) 
      {
        // Comment
        ++x;
      }
    END_OF_CODE
    assert_equal(expected, rebraceToString(input), "Should move brace followed by comment")
  end
  
  def test_comment_ending_no_spacing
    input = <<-END_OF_CODE
      if (x == 1) {// Comment
        ++x;
      }
    END_OF_CODE
    expected = <<-END_OF_CODE
      if (x == 1) 
      {
        // Comment
        ++x;
      }
    END_OF_CODE
    assert_equal(expected, rebraceToString(input), "Should move brace followed by comment without separation")
  end
  
  def test_comment_ending_pre_spacing
    input = <<-END_OF_CODE
      if (x == 1) {    // Comment
        ++x;
      }
    END_OF_CODE
    expected = <<-END_OF_CODE
      if (x == 1) 
      {
        // Comment
        ++x;
      }
    END_OF_CODE
    assert_equal(expected, rebraceToString(input), "Should move brace followed by comment and extra separation")
  end
  
  def test_comment_ending_post_spacing
    input = <<-END_OF_CODE
      if (x == 1) {    // Comment    
        ++x;
      }
    END_OF_CODE
    expected = <<-END_OF_CODE
      if (x == 1) 
      {
        // Comment    
        ++x;
      }
    END_OF_CODE
    assert_equal(expected, rebraceToString(input), "Should move brace followed by comment with trailing space")
  end

  def test_star_comment_ending
    input = <<-END_OF_CODE
      if (x == 1) { /* Comment */
        ++x;
      }
    END_OF_CODE
    expected = <<-END_OF_CODE
      if (x == 1) 
      {
        /* Comment */
        ++x;
      }
    END_OF_CODE
    assert_equal(expected, rebraceToString(input), "Should move brace followed by star comment")
  end
  
  def test_star_comment_ending_no_spacing
    input = <<-END_OF_CODE
      if (x == 1) {/* Comment */
        ++x;
      }
    END_OF_CODE
    expected = <<-END_OF_CODE
      if (x == 1) 
      {
        /* Comment */
        ++x;
      }
    END_OF_CODE
    assert_equal(expected, rebraceToString(input), "Should move brace followed by star comment without separation")
  end
  
  def test_star_comment_ending_pre_spacing
    input = <<-END_OF_CODE
      if (x == 1) {    /* Comment */
        ++x;
      }
    END_OF_CODE
    expected = <<-END_OF_CODE
      if (x == 1) 
      {
        /* Comment */
        ++x;
      }
    END_OF_CODE
    assert_equal(expected, rebraceToString(input), "Should move brace followed by star comment and extra separation")
  end
  
  def test_star_comment_ending_post_spacing
    input = <<-END_OF_CODE
      if (x == 1) {    /* Comment */    
        ++x;
      }
    END_OF_CODE
    expected = <<-END_OF_CODE
      if (x == 1) 
      {
        /* Comment */
        ++x;
      }
    END_OF_CODE
    assert_equal(expected, rebraceToString(input), "Should move brace followed by star comment with trailing space")
  end
  
  # --------------- Pointer Tests --------------- #
  
  def test_pointer_no_change
    input = <<-END_OF_CODE
      NSString *myString = @"string";
    END_OF_CODE
    expected = <<-END_OF_CODE
      NSString *myString = @"string";
    END_OF_CODE
    assert_equal(expected, rebraceToString(input), "Should not have modified correct pointer declaration")
  end
  
  def test_pointer_class_side
    input = <<-END_OF_CODE
      NSString* myString = @"string";
    END_OF_CODE
    expected = <<-END_OF_CODE
      NSString *myString = @"string";
    END_OF_CODE
    assert_equal(expected, rebraceToString(input), "Should have moved class-adjacent pointer")
  end
  
  def test_pointer_mid_point
    input = <<-END_OF_CODE
      NSString * myString = @"string";
    END_OF_CODE
    expected = <<-END_OF_CODE
      NSString *myString = @"string";
    END_OF_CODE
    assert_equal(expected, rebraceToString(input), "Should have moved mid-point pointer")
  end
  
  def test_pointer_class_side_braced
    input = <<-END_OF_CODE
      if ((NSString* myString = [file nextLine]) != nil) {
        NSLog(@"%@", myString);
      }
    END_OF_CODE
    expected = <<-END_OF_CODE
      if ((NSString *myString = [file nextLine]) != nil) 
      {
        NSLog(@"%@", myString);
      }
    END_OF_CODE
    assert_equal(expected, rebraceToString(input), "Should have moved class-adjacent pointer and brace")
  end
  
  def test_pointer_mid_point_braced
    input = <<-END_OF_CODE
      if ((NSString* myString = [file nextLine]) != nil) {
        NSLog(@"%@", myString);
      }
    END_OF_CODE
    expected = <<-END_OF_CODE
      if ((NSString *myString = [file nextLine]) != nil) 
      {
        NSLog(@"%@", myString);
      }
    END_OF_CODE
    assert_equal(expected, rebraceToString(input), "Should have moved mid-point pointer and brace")
  end
  
  def test_basic_pointer_no_change
    input = <<-END_OF_CODE
      int x = 8;
      int *myInt = &x;
    END_OF_CODE
    expected = <<-END_OF_CODE
      int x = 8;
      int *myInt = &x;
    END_OF_CODE
    assert_equal(expected, rebraceToString(input), "Should not have modified correct int pointer declaration")
  end
  
  def test_basic_pointer_type_side
    input = <<-END_OF_CODE
      int x = 8;
      int* myInt = &x;
    END_OF_CODE
    expected = <<-END_OF_CODE
      int x = 8;
      int *myInt = &x;
    END_OF_CODE
    assert_equal(expected, rebraceToString(input), "Should have moved type-adjacent int pointer")
  end
  
  def test_basic_pointer_mid_point
    input = <<-END_OF_CODE
      int x = 8;
      int * myInt = &x;
    END_OF_CODE
    expected = <<-END_OF_CODE
      int x = 8;
      int *myInt = &x;
    END_OF_CODE
    assert_equal(expected, rebraceToString(input), "Should have moved mid-point int pointer")
  end
  
end