from transformers import AutoModel, AutoTokenizer, pipeline

tokenizer = AutoTokenizer.from_pretrained("turkish-shopping-category-classification")
model = AutoModel.from_pretrained("turkish-shopping-category-classification")
# pipe = pipeline(model=model, tokenizer=tokenizer)

EXCLUDING_KEYWORDS = ['toplam', 'topkdv', 'garanti', 'kredi', 'karti']

def get_category_item(item):
    s = item[0].lower()
    if any(keyword in s for keyword in EXCLUDING_KEYWORDS):
        return None
    tokens = tokenizer(s)
    output = model(tokens)
    print(output)
    return output
    return category_id

if __name__ == "__main__":
    print(get_category_item(('Öğünler', 1)))


