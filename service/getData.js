export async function getData() {
    const data = await fetch(
      "./data.json"
    )
      .then(async (res) => {
        if (Math.floor(res.status / 100) === 2) {
          return res.json()
        }
  
        return null
      })
      .catch((err) => console.error(err));
      
    return data;
}