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
  
end