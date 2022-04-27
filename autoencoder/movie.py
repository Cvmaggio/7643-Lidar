from torch.utils.data import Dataset, DataLoader
import os
from tqdm.notebook import tqdm
from ml_things import fix_text
import io
# import torchtext
import re

import contractions





SOS_token = '<sos>'
EOS_token = '<eos>'
PAD_token = '<pad>'


class MovieReviewsTextDataset(Dataset):
  r"""PyTorch Dataset class for loading data.

  This is where the data parsing happens.

  This class is built with reusability in mind.

  Arguments:

    path (:obj:`str`):
        Path to the data partition.

  """

  def __init__(self, path, max_len=50):

    # Check if path exists.
    if not os.path.isdir(path):
      # Raise error if path is invalid.
      raise ValueError('Invalid `path` variable! Needs to be a directory')

    self.texts = []
    self.encoded_text = []
    self.labels = []
    #self.fields = {'src': <torchtext.data.field.Field object at 0x7f3764fdf390>, 'trg': <torchtext.data.field.Field object at 0x7f3794347d10>}
    
    # Since the labels are defined by folders with data we loop
    # through each label.
    for label  in ['pos', 'neg']:
      sentiment_path = os.path.join(path, label)

      # Get all files from path.
      files_names = os.listdir(sentiment_path)#[:10] # Sample for debugging.
      # Go through each file and read its content.
      for file_name in tqdm(files_names, desc=f'{label} Files'):
        file_path = os.path.join(sentiment_path, file_name)

        # Read content.
        content = io.open(file_path, mode='r', encoding='utf-8').read()
        # Fix any unicode issues.
        content = fix_text(content)
        # Save content.
        
        content = content.lower().strip()
        # content = re.sub(r'([.!?])', r' \1', content)
        content = re.sub(r'[^a-zA-Z\']+', r' ', content)
        content = contractions.fix(content)
        content = re.sub(r'(\'s)', r'', content)

        content = content.split()
        content = content[:max_len]
        if len(content) < max_len:
          content += [PAD_token for _ in range(max_len - len(content))]
        content.insert(0, SOS_token)
        content.append(EOS_token)
        self.texts.append(content)
        #content_list = content.split()
        #print(f"content_list: {content_list}")
        #self.encoded_text.append(vocabulary.vocab.forward(content_list))
        # Save labels.
        self.labels.append(label)

    # Number of examples.
    self.n_examples = len(self.labels)

    return


  def __len__(self):
    r"""When used `len` return the number of examples.

    """

    return self.n_examples


  def __getitem__(self, item):
    r"""Given an index return an example from the position.

    Arguments:

      item (:obj:`int`):
          Index position to pick an example to return.

    Returns:
      :obj:`Dict[str, str]`: Dictionary of inputs that are used to feed
      to a model.

    """

    # return self.texts[item], self.labels[item]
    return {'text':self.texts[item], 'label':self.labels[item]}




# citation: https://pytorch.org/tutorials/intermediate/seq2seq_translation_tutorial.html



class Lang:
    def __init__(self, name, max_len=20):
        self.name = name
        self.max_len = max_len
        self.word2index = {SOS_token: 0, EOS_token: 1, PAD_token: 2}
        self.word2count = {}
        self.index2word = {0: SOS_token, 1: EOS_token, 2: PAD_token}
        self.n_words = 3  # Count SOS and EOS

    def addSentence(self, sentence):
        for word in sentence:
            if word not in (SOS_token, EOS_token, PAD_token):
              self.addWord(word)

    def addWord(self, word):
        if word not in self.word2index:
            self.word2index[word] = self.n_words
            self.word2count[word] = 1
            self.index2word[self.n_words] = word
            self.n_words += 1
        else:
            self.word2count[word] += 1