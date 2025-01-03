This is a recreation of a problem I needed to solve for a Document Imaging Manager. Notes are in each SQL script to further elaborate.

The problem:

  Each day labels are placed on a physical x-ray or document prior to being scanned   
  The label contains an alphanumeric ID in this format: [YYYYMM][X || P][6 digit zero-padded number] 
  X-rays are represented with an X and all other documents are represented with a P 
  2 million labels can be used each month - 1 million with X and 1 million with P 
  The document imaging manager needs to identify any labels in a sequence that were not scanned for auditing purposes 
  
  Example: 
  
  For the range 202412X000054 to 202412X00059 
  If we have the following in the database: 
      202412X000054 
      202412X000055 
      202412X000056 
      202412X000059 
  Then return: 
      202412X000057 
      202412X000058 
