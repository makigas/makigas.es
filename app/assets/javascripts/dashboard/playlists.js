$(document).ready(function() {
  $('.video-move-up').each(function() {
    $button = $(this);
    $(this).closest('form').on('ajax:success', function(e) {
      $row = $(this).closest('tr');
      $previous = $row.prev();
      $row.addClass('moving-up');
      $previous.addClass('moving-down');

      setTimeout(function() {
        // Fetch position numbers as they will change as well.
        $rowNumber = $row.find('td:first-child').text();
        $prevNumber = $previous.find('td:first-child').text();

        // Actually do the swap.
        $row.find('td:first-child').text($prevNumber);
        $previous.find('td:first-child').text($rowNumber);
        $previous.insertAfter($row);

        // Remove class.
        $row.removeClass('moving-up');
        $previous.removeClass('moving-down');
      }, 250);
    });
  });

  $('.video-move-down').each(function() {
    $button = $(this);
    $(this).closest('form').on('ajax:success', function(e) {
      $row = $(this).closest('tr');
      $next = $row.next();
      $row.addClass('moving-down');
      $next.addClass('moving-up');

      setTimeout(function() {
        // Fetch position numbers.
        $rowNumber = $row.find('td:first-child').text();
        $nextNumber = $next.find('td:first-child').text();

        // Do the swap.
        $row.find('td:first-child').text($nextNumber);
        $next.find('td:first-child').text($rowNumber);
        $row.insertAfter($next);

        // Remove class.
        $row.removeClass('moving-down');
        $next.removeClass('moving-up');
      }, 250);
    });
  });
});